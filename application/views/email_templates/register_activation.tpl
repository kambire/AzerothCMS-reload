<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="utf-8">
        <title>Verificación de Cuenta</title>
        <link href="https://fonts.googleapis.com/css?family=Nunito:400,600,700&display=swap" rel="stylesheet">
        <style>
            @media only screen and (max-width: 600px) {
                .container { width: 100% !important; }
                .button { width: 100% !important; text-align: center; }
            }
        </style>
    </head>

    <body style="font-family: 'Nunito', sans-serif; font-size: 16px; font-weight: 400; background-color: #f4f7f9; margin: 0; padding: 0;">
        <div style="padding: 40px 0;">
            <table cellpadding="0" cellspacing="0" class="container" style="max-width: 600px; border: none; margin: 0 auto; border-radius: 8px; overflow: hidden; background-color: #ffffff; box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);">
                <thead>
                    <tr style="background-color: #2f55d4; text-align: center; color: #ffffff;">
                        <th scope="col" style="padding: 25px; font-size: 26px; font-weight: 700; letter-spacing: 1px;">
                            <?php echo $server_name; ?>
                        </th>
                    </tr>
                </thead>

                <tbody>
                    <tr>
                        <td style="padding: 40px 30px 10px; color: #161c2d;">
                            <h2 style="font-size: 20px; font-weight: 700; margin: 0;">¡Bienvenido/a, <?php echo $username; ?>!</h2>
                        </td>
                    </tr>
                    
                    <tr>
                        <td style="padding: 10px 30px 20px; color: #556070; line-height: 1.6;">
                            <?php echo $message; ?>
                            <p style="margin-top: 20px;">
                                Nos alegra mucho tenerte en nuestra comunidad. Haz clic en el botón inferior para activar tu cuenta y poder ingresar al juego.
                            </p>
                        </td>
                    </tr>
                    <?php 
                        preg_match('/href="([^"]+)"/', $message, $match);
                        $action_url = isset($match[1]) ? $match[1] : $url; 
                    ?>
                    <tr>
                        <td style="padding: 20px 30px; text-align: center;">
                            <a href="<?php echo $action_url; ?>" style="background-color: #2f55d4; color: #ffffff; padding: 15px 30px; text-decoration: none; border-radius: 5px; font-weight: 600; font-size: 16px; display: inline-block;">
                                Activar Cuenta
                            </a>
                        </td>
                    </tr>

                    <tr>
                        <td style="padding: 20px 30px; color: #8492a6; font-size: 13px; line-height: 1.5;">
                            Si tienes problemas con el botón de arriba, copia y pega este enlace en tu navegador: <br>
                            <a href="<?php echo $action_url; ?>" style="color: #2f55d4; word-break: break-all;"><?php echo $action_url; ?></a>
                        </td>
                    </tr>

                    <tr>
                        <td style="padding: 20px 30px; border-top: 1px solid #edf2f7; color: #8492a6; font-size: 14px; font-style: italic;">
                            Si no abriste esta cuenta, puedes usar nuestro equipo de soporte para comunicarte con nosotros.
                        </td>
                    </tr>

                    <tr>
                        <td style="padding: 30px 30px 40px; color: #161c2d; font-weight: 600;">
                            Atentamente, <br>
                            <span style="color: #2f55d4;">Equipo de Soporte de <?php echo $server_name; ?></span>
                        </td>
                    </tr>

                    <tr>
                        <td style="padding: 20px; color: #94a3b8; background-color: #f8f9fc; text-align: center; font-size: 12px;">
                            © <?php echo date("Y"); ?> <?php echo $server_name; ?>. Todos los derechos reservados.
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </body>
</html>
