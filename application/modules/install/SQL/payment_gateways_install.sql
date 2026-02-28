-- ============================================================
-- AzerothCMS — Payment Gateway Module
-- Full Installation SQL
-- Generated: 2026-02-28
--
-- Run this script ONCE on a fresh install or on any existing
-- server that doesn't yet have these payment tables.
-- All statements use IF NOT EXISTS / INSERT IGNORE so they
-- are safe to re-run without corrupting existing data.
-- ============================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ============================================================
-- 1. STORE PAYMENT METHODS
--    Central registry of all available payment gateways.
--    Managed from Admin → Store → Payment Gateways.
-- ============================================================

CREATE TABLE IF NOT EXISTS `store_payment_methods` (
    `id`           INT(11)       NOT NULL AUTO_INCREMENT,
    `name`         VARCHAR(255)  NOT NULL,
    `display_name` VARCHAR(255)  NOT NULL,
    `is_active`    TINYINT(1)    NOT NULL DEFAULT 0,
    `config`       TEXT                   DEFAULT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Seed default gateways — INSERT IGNORE means safe to re-run
INSERT IGNORE INTO `store_payment_methods` (`name`, `display_name`, `is_active`, `config`) VALUES
    ('offline',  'Offline Payment / Bank Transfer', 1,
        '{"beneficiary":"","bank_name":"","account_number":"","account_type":"","currency":"PYG","pix_key":"","instructions":""}'),
    ('paypal',   'PayPal', 0,
        '{"client_id":"","secret":"","mode":"sandbox","currency":"USD"}'),
    ('pagopar',  'Pagopar (Paraguay)', 0,
        '{"public_key":"","private_key":"","currency":"PYG"}'),
    ('bancard',  'Bancard vPOS (Paraguay)', 0,
        '{"public_key":"","private_key":"","mode":"sandbox","currency":"PYG","exchange_rate":"7500"}'),
    ('skrill',   'Skrill', 0,
        '{"merchant_email":"","secret_word":"","currency":"USD"}');

-- ============================================================
-- 2. ORDER LOG — Add payment tracking columns
--    The base `order_log` table already exists after the main
--    FusionCMS install. We only add new columns if missing.
-- ============================================================

-- payment_method: how the order was paid ('points','paypal','offline',etc.)
ALTER TABLE `order_log`
    ADD COLUMN IF NOT EXISTS `payment_method` VARCHAR(50)      DEFAULT 'points'    COMMENT 'Gateway used: points / paypal / offline / pagopar / bancard',
    ADD COLUMN IF NOT EXISTS `payment_id`     VARCHAR(100)     DEFAULT NULL         COMMENT 'External transaction/reference ID',
    ADD COLUMN IF NOT EXISTS `status`         VARCHAR(20)      DEFAULT 'completed'  COMMENT 'completed | pending | failed',
    ADD COLUMN IF NOT EXISTS `amount`         DECIMAL(10,2)    DEFAULT 0.00         COMMENT 'Amount charged in the gateway currency';

-- Backfill historical orders
UPDATE `order_log` SET `status` = 'completed', `payment_method` = 'points' WHERE `completed` = 1  AND `status` IS NULL;
UPDATE `order_log` SET `status` = 'failed',    `payment_method` = 'points' WHERE `completed` = 0  AND `status` IS NULL;

-- ============================================================
-- 3. OFFLINE PAYMENTS LOG
--    Records manual payment requests submitted by players.
--    Admin reviews and approves/rejects from Donate → Offline.
-- ============================================================

CREATE TABLE IF NOT EXISTS `donate_offline_payments` (
    `id`          INT(11)                                         NOT NULL AUTO_INCREMENT,
    `user_id`     INT(11)                                         NOT NULL,
    `amount`      DECIMAL(10,2)                                   NOT NULL,
    `points`      INT(11)                                         NOT NULL,
    `method`      VARCHAR(255)                                    NOT NULL COMMENT 'Western Union / Bank Transfer / PIX…',
    `reference`   VARCHAR(255)                                    NOT NULL COMMENT 'Transaction ID / receipt code',
    `status`      ENUM('pending','completed','rejected')          NOT NULL DEFAULT 'pending',
    `create_time` INT(11)                                         NOT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_user`   (`user_id`),
    KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- 4. PAYPAL LOGS
--    Original PayPal donation tracking table.
--    Already exists in FusionCMS — recreated here for clean
--    installs that don't have it.
-- ============================================================

CREATE TABLE IF NOT EXISTS `paypal_logs` (
    `id`             INT(11)      NOT NULL AUTO_INCREMENT,
    `user_id`        INT(11)      NOT NULL,
    `payment_id`     VARCHAR(100) NOT NULL DEFAULT '',
    `hash`           VARCHAR(64)  NOT NULL DEFAULT '',
    `total`          VARCHAR(20)  NOT NULL DEFAULT '',
    `points`         INT(11)      NOT NULL DEFAULT 0,
    `create_time`    INT(11)      NOT NULL DEFAULT 0,
    `currency`       VARCHAR(10)  NOT NULL DEFAULT 'USD',
    `error`          TEXT                  DEFAULT NULL,
    `status`         TINYINT(1)   NOT NULL DEFAULT 0,
    `invoice_number` VARCHAR(100)          DEFAULT NULL,
    `payer_email`    VARCHAR(255)          DEFAULT NULL,
    `token`          VARCHAR(255)          DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_user`   (`user_id`),
    KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- 5. PAGOPAR LOGS
--    Tracks every Pagopar payment attempt.
--    hash = the unique hash returned by Pagopar API.
-- ============================================================

CREATE TABLE IF NOT EXISTS `pagopar_logs` (
    `id`          INT(11)                                  NOT NULL AUTO_INCREMENT,
    `user_id`     INT(11)                                  NOT NULL,
    `order_id`    VARCHAR(100)                             NOT NULL COMMENT 'Internal order reference',
    `hash`        VARCHAR(255)                             NOT NULL COMMENT 'Hash returned by Pagopar API',
    `points`      INT(11)                                  NOT NULL DEFAULT 0,
    `amount_usd`  DECIMAL(10,2)                            NOT NULL DEFAULT 0.00,
    `amount_pyg`  INT(11)                                  NOT NULL DEFAULT 0,
    `status`      ENUM('pending','completed','failed')     NOT NULL DEFAULT 'pending',
    `created_at`  INT(11)                                  NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_hash`  (`hash`),
    KEY `idx_user`        (`user_id`),
    KEY `idx_status`      (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- 6. BANCARD LOGS
--    Tracks every Bancard vPOS payment attempt.
--    shop_process_id must be unique per Bancard spec.
--    process_id = token returned by singleBuy to load iframe.
-- ============================================================

CREATE TABLE IF NOT EXISTS `bancard_logs` (
    `id`              INT(11)                               NOT NULL AUTO_INCREMENT,
    `user_id`         INT(11)                               NOT NULL,
    `shop_process_id` VARCHAR(20)                           NOT NULL COMMENT 'YYYYMMDD+orderId+attempt (max 15 digits)',
    `process_id`      VARCHAR(255)                          NOT NULL DEFAULT '' COMMENT 'Token from singleBuy API used to embed iframe',
    `points`          INT(11)                               NOT NULL DEFAULT 0,
    `amount_usd`      DECIMAL(10,2)                         NOT NULL DEFAULT 0.00,
    `amount_pyg`      INT(11)                               NOT NULL DEFAULT 0,
    `status`          ENUM('pending','completed','failed')  NOT NULL DEFAULT 'pending',
    `created_at`      INT(11)                               NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_shop_process` (`shop_process_id`),
    KEY `idx_user`               (`user_id`),
    KEY `idx_status`             (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- 7. PAYPAL DONATE PACKAGES
--    Donation packages shown on the Donate page.
--    Admin manages from Donate → Admin → Packages.
-- ============================================================

CREATE TABLE IF NOT EXISTS `paypal_donate` (
    `id`     INT(11)       NOT NULL AUTO_INCREMENT,
    `price`  DECIMAL(10,2) NOT NULL DEFAULT 0.00 COMMENT 'Price in USD',
    `points` INT(11)       NOT NULL DEFAULT 0    COMMENT 'DP awarded',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Sample packages (only inserted if table is empty)
INSERT INTO `paypal_donate` (`price`, `points`)
SELECT * FROM (
    SELECT 5.00,  100  UNION ALL
    SELECT 10.00, 250  UNION ALL
    SELECT 20.00, 600  UNION ALL
    SELECT 50.00, 1800
) AS tmp
WHERE NOT EXISTS (SELECT 1 FROM `paypal_donate` LIMIT 1);

-- ============================================================
-- 8. MONTHLY INCOME
--    Tracks total donations per calendar month.
-- ============================================================

CREATE TABLE IF NOT EXISTS `monthly_income` (
    `id`     INT(11)       NOT NULL AUTO_INCREMENT,
    `month`  VARCHAR(7)    NOT NULL COMMENT 'YYYY-MM',
    `amount` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_month` (`month`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- DONE
-- ============================================================

SET FOREIGN_KEY_CHECKS = 1;

-- Quick verification (comment out if running in a migration tool)
-- SELECT 'store_payment_methods'    AS `table`, COUNT(*) AS `gateways`      FROM store_payment_methods
-- UNION ALL
-- SELECT 'donate_offline_payments'  AS `table`, COUNT(*) AS `rows`          FROM donate_offline_payments
-- UNION ALL
-- SELECT 'pagopar_logs'             AS `table`, COUNT(*) AS `rows`          FROM pagopar_logs
-- UNION ALL
-- SELECT 'bancard_logs'             AS `table`, COUNT(*) AS `rows`          FROM bancard_logs;
