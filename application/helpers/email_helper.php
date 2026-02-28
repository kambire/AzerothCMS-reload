<?php

if (!defined('BASEPATH'))
    exit('No direct script access allowed');

use App\Config\Services;

/**
 * Send mail
 *
 * @param String $receiver
 * @param String $subject
 * @param String $username
 * @param String $message
 * @param $templateId
 * @return bool|string
 */
function sendMail(string $receiver, string $subject, string $username, string $message, $templateId)
{
    static $CI;

    if (!$CI) {
        $CI = & get_instance();
    }

    // Make sure the website has SMTP available
    if (!$CI->config->item('has_smtp')) {
        return false;
    }

    $CI->load->config('smtp');

    $config = [];
    $config['mailType'] = 'html';
    $config['charset'] = 'UTF-8';
    $config['newline'] = "\r\n";
    $config['CRLF'] = "\r\n";
    $config['SMTPHost'] = 'localhost'; // Fallback por defecto

    // Pass the custom SMTP settings if any
    if ($CI->config->item('smtp_protocol') == 'smtp') {
        $config['protocol'] = 'smtp';
        $config['SMTPHost'] = $CI->config->item('smtp_host');
        $config['SMTPUser'] = $CI->config->item('smtp_user');
        $config['SMTPPass'] = $CI->config->item('smtp_pass');
        $config['SMTPPort'] = (int)$CI->config->item('smtp_port');
        $config['SMTPCrypto'] = $CI->config->item('smtp_crypto');
    }
    else {
        $config['protocol'] = 'mail';
    }

    $sender = $CI->config->item('smtp_sender');
    $email = Services::email();
    $email->initialize($config);

    // Set email data
    $email->setFrom($sender ?: 'no-reply@localhost', $CI->config->item('server_name') ?: 'FusionCMS');
    $email->setTo($receiver);
    $email->setSubject($subject);

    // Template processing
    $data = [
        'username' => $username,
        'message' => $message,
        'server_name' => $CI->config->item('server_name'),
        'url' => $CI->template->page_url,
    ];

    $template = $CI->cms_model->getTemplate($templateId);
    if ($template) {
        $body = $CI->load->view('email_templates/' . $template['template_name'], $data, true);
        $email->setMessage($body);
    }
    else {
        $email->setMessage($message);
    }

    // Send the email
    if (!$email->send()) {
        $debugger = $email->printDebugger(['headers', 'subject', 'body']);
        // Store technical error in a way that the controller can access it if needed
        // For now, we return the debugger string so the caller can decide what to do
        return $debugger;
    }

    $data2 = [
        'uid' => $CI->external_account_model->getIdByEmail($receiver),
        'email' => $receiver,
        'subject' => $subject,
        'message' => $message,
        'timestamp' => time()
    ];

    $CI->db->table('email_log')->insert($data2);

    return true;
}
