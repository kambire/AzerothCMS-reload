<?php

class Store_model extends CI_Model
{
    public function __construct()
    {
        parent::__construct();

        try {
            // Create the store_payment_methods table if not exists
            $this->db->query("CREATE TABLE IF NOT EXISTS `store_payment_methods` (
                `id` int(11) NOT NULL AUTO_INCREMENT,
                `name` varchar(255) NOT NULL,
                `display_name` varchar(255) NOT NULL,
                `is_active` tinyint(1) DEFAULT '0',
                `config` text DEFAULT NULL,
                PRIMARY KEY (`id`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8;");

            // Seed default gateways (INSERT IGNORE = safe to run on every boot)
            $this->db->query("INSERT IGNORE INTO store_payment_methods (name, display_name, is_active, config) VALUES
                ('offline', 'Offline Payment / Bank', 1, '{}'),
                ('paypal', 'PayPal', 0, '{\"client_id\":\"\",\"secret\":\"\"}'),
                ('pagopar', 'Pagopar (Paraguay)', 0, '{\"public_key\":\"\",\"private_key\":\"\"}'),
                ('bancard', 'Bancard vPOS (Paraguay)', 0, '{\"public_key\":\"\",\"private_key\":\"\",\"mode\":\"sandbox\",\"currency\":\"PYG\",\"exchange_rate\":\"7500\"}'),
                ('skrill', 'Skrill', 0, '{\"merchant_email\":\"\",\"secret_word\":\"\"}')
            ");

            // Add payment columns to order_log if not yet present
            $columnsResult = $this->db->query("SHOW COLUMNS FROM order_log LIKE 'payment_method'");
            if ($columnsResult && $columnsResult->getNumRows() == 0) {
                $this->db->query("ALTER TABLE order_log
                    ADD COLUMN payment_method VARCHAR(50) DEFAULT 'points',
                    ADD COLUMN payment_id VARCHAR(100) DEFAULT NULL,
                    ADD COLUMN status VARCHAR(20) DEFAULT 'completed',
                    ADD COLUMN amount DECIMAL(10,2) DEFAULT '0.00'");

                $this->db->query("UPDATE order_log SET status = 'completed', payment_method = 'points' WHERE completed = 1");
                $this->db->query("UPDATE order_log SET status = 'failed', payment_method = 'points' WHERE completed = 0");
            }
        }
        catch (\Exception $e) {
            // Migrations are best-effort; don't crash the store if they fail
            log_message('error', 'Store_model migration error: ' . $e->getMessage());
        }
    }

    public function getPaymentMethods()
    {
        return $this->db->table('store_payment_methods')->get()->getResultArray();
    }

    public function getActivePaymentMethods()
    {
        return $this->db->table('store_payment_methods')->where('is_active', 1)->get()->getResultArray();
    }

    public function updatePaymentMethod($id, $is_active, $config)
    {
        $this->db->table('store_payment_methods')->where('id', $id)->update([
            'is_active' => $is_active,
            'config' => $config
        ]);
    }

    public function getPendingOfflineOrders()
    {
        $query = $this->db->query("SELECT * FROM order_log WHERE payment_method = 'offline' AND status = 'pending' ORDER BY id DESC");
        return ($query->getNumRows() > 0) ? $query->getResultArray() : false;
    }

    public function getOrdersByStatus($status)
    {
        $query = $this->db->query("SELECT * FROM order_log WHERE status = ? ORDER BY id DESC LIMIT 50", [$status]);
        return ($query->getNumRows() > 0) ? $query->getResultArray() : false;
    }

    public function getItems($realm)
    {
        $query = $this->db->query("SELECT DISTINCT store_items.*
									FROM store_items
									INNER JOIN store_groups ON store_items.group = store_groups.id
									WHERE store_items.realm = ?
									GROUP BY store_items.id
									ORDER BY store_groups.orderNumber ASC, store_items.group ASC, store_items.id ASC;", [$realm]);

        if ($query->getNumRows() > 0) {
            return $query->getResultArray();
        }
        else {
            return false;
        }
    }

    public function getItem($id)
    {
        $query = $this->db->table('store_items')->select()->where(['id' => $id])->orderBy('group', 'ASC')->get();

        if ($query->getNumRows() > 0) {
            $result = $query->getResultArray();

            return $result[0];
        }
        else {
            return false;
        }
    }

    public function getStoreGroups(): false|array
    {
        $query = $this->db->table('store_groups')->select()->get();

        if ($query->getNumRows() > 0) {
            return $query->getResultArray();
        }
        else {
            return false;
        }
    }

    public function logOrderExt($vp, $dp, $cart, $payment_method = 'points', $status = 'completed', $amount = 0.00, $payment_id = null): int
    {
        $data = [
            'vp_cost' => $vp,
            'dp_cost' => $dp,
            'cart' => json_encode($cart),
            'completed' => ($status == 'completed' ? 1 : 0),
            'user_id' => $this->user->getId(),
            'timestamp' => time(),
            'payment_method' => $payment_method,
            'status' => $status,
            'amount' => $amount,
            'payment_id' => $payment_id
        ];

        $this->db->table('order_log')->insert($data);
        return $this->db->insertID();
    }

    public function logOrder($vp, $dp, $cart): void
    {
        $this->logOrderExt($vp, $dp, $cart);
    }

    public function completeOrder(): void
    {
        $this->db->query("UPDATE order_log SET completed = '1' WHERE user_id = ? ORDER BY id DESC LIMIT 1", [$this->user->getId()]);
    }

    public function getOrders($completed): array |false
    {
        if ($completed) {
            $query = $this->db->query("SELECT * FROM order_log WHERE completed = ? ORDER BY id DESC LIMIT 10", [$completed]);
        }
        else {
            $query = $this->db->query("SELECT * FROM order_log WHERE completed = ? AND `timestamp` > ? ORDER BY id DESC", [$completed, time() - 60 * 60 * 24 * 7]);
        }

        if ($query->getNumRows()) {
            return $query->getResultArray();
        }
        else {
            return false;
        }
    }

    public function getOrder($id)
    {
        $query = $this->db->query("SELECT * FROM order_log WHERE id = ?", [$id]);

        if ($query->getNumRows()) {
            $row = $query->getResultArray();

            return $row[0];
        }
        else {
            return false;
        }
    }

    public function findByUserId($type, $string): array |false
    {
        $query = $this->db->query("SELECT * FROM order_log WHERE `user_id` = ? AND `completed` = ?", [$string, $type]);

        if ($query->getNumRows()) {
            return $query->getResultArray();
        }
        else {
            return false;
        }
    }

    public function refund($user_id, $vp, $dp): void
    {
        $this->db->query("UPDATE account_data SET vp = vp + ?, dp = dp + ? WHERE id = ?", [$vp, $dp, $user_id]);
    }

    public function deleteLog($id): void
    {
        $this->db->query("DELETE FROM order_log WHERE id = ?", [$id]);
    }
}
