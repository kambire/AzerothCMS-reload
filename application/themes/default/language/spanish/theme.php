<?php defined('BASEPATH') or exit('No direct script access allowed');

if (!isset($lang) || !is_array($lang))
    $lang = [];

/**
 * - RTL -----------------------------------------------------
 * -----------------------------------------------------------
 */
$lang['isRTL'] = 0;

/**
 * - Global --------------------------------------------------
 * -----------------------------------------------------------
 */
$lang = array_merge($lang, [
    'global_or' => 'o',
    'global_icon' => 'Icono',
    'global_okay' => 'Aceptar',
    'global_accept' => 'Aceptar',
    'global_reject' => 'Rechazar',
    'global_cancel' => 'Cancelar',
    'global_online' => 'En línea',
    'global_offline' => 'Desconectado',
    'global_loading' => 'Cargando...',
    'global_user_avatar' => 'Avatar de %s'
]);

/**
 * - Main Template -------------------------------------------
 * -----------------------------------------------------------
 */
$lang = array_merge($lang, [
    # Logo
    'logo' => 'Bienvenido a %s',

    # Menu
    'nav' => 'Navegación',

    # User buttons
    'account' => 'Cuenta',
    'register' => 'Registrarse',

    # Banner 1
    'banner01_text01' => 'Bienvenido a %s',
    'banner01_text02' => 'Únete a nuestra comunidad y vive la mejor experiencia de juego. ¡Comienza tu aventura hoy!',

    # Banner 2
    'banner02_text01' => 'Aprende cómo',
    'banner02_text02' => 'conectarte',
    'banner02_text03' => 'a nuestros reinos',
    'banner02_text04' => 'haz clic para leer',

    # Copyright
    'copyright' => '%s &copy; Derechos reservados %s'
]);
