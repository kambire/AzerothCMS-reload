-- Limpiar grupos actuales y agregar los de demo
TRUNCATE TABLE `store_groups`;

INSERT INTO `store_groups` (`id`, `title`, `icon`, `orderNumber`) VALUES
(1, 'Mounts & Pets', 'fa-solid fa-paw', 1),
(2, 'VIP & Services', 'fa-solid fa-star', 2);


-- Limpiar items de tienda si hubieran y agregar los 3 items demo para WotLK
TRUNCATE TABLE `store_items`;

INSERT INTO `store_items` (`id`, `itemid`, `itemcount`, `name`, `quality`, `vp_price`, `dp_price`, `realm`, `description`, `icon`, `group`, `query`, `query_database`, `query_need_character`, `command`, `command_need_character`, `require_character_offline`, `tooltip`) VALUES
(1, '50818', '1', 'Invincible''s Reins', 4, 150, 20, 1, 'Teaches you how to summon this mount. This is a very fast mount.', 'ability_mount_pegasus', 1, NULL, '', 0, NULL, 0, 0, 1),
(2, '49284', '1', 'Reins of the Swift Spectral Tiger', 4, 200, 25, 1, 'Teaches you how to summon this mount.', 'ability_mount_spectraltiger', 1, NULL, '', 0, NULL, 0, 0, 1),
(3, '54847', '1', 'Lil'' K.T.', 4, 50, 10, 1, 'Right Click to summon and dismiss Lil'' K.T.', 'inv_pet_lilkt', 1, NULL, '', 0, NULL, 0, 0, 1);
