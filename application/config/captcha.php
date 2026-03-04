<?php

/**
 *
 * Enable captcha for site
 *
 */
$config['use_captcha'] = false;

/**
 *
 * What type of captcha?
 *
 * 'recaptcha'  = Google Recaptcha v2
 * 'recaptcha3' = Google Recaptcha v3
 * 'inbuilt'    = inbuilt captcha system
 *
 */
$config["captcha_type"] = 'inbuilt';

/**
 *
 * After how many tries should a captcha pop up?
 *
 */
$config['captcha_attemps'] = 9999; // Desactivado: nunca aparece automaticamente

/**
 *
 * After how many tries should we block an IP address?
 * How many minutes should an IP address remain blocked?
 *
 */
$config['block_attemps'] = 9999; // Desactivado: nunca bloquea por intentos
$config['block_duration'] = 15;

/**
 *
 * The site key
 * get site key @ www.google.com/recaptcha/admin
 *
 */
$config["recaptcha_site_key"] = "";

/**
 *
 * The secret key
 * get secret key @ www.google.com/recaptcha/admin
 *
 */
$config["recaptcha_secret_key"] = "";

// Theme
$config['recaptcha_theme'] = 'dark'; // dark - light
