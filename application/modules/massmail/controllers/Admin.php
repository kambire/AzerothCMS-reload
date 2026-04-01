<?php

use MX\MX_Controller;

class Admin extends MX_Controller
{
    public function __construct()
    {
        parent::__construct();

        $this->load->library('administrator');
        $this->load->model('massmail_model');
        $this->load->model('external_account_model');
        $this->load->helper('email_helper');

        // Allow Cron execution via CLI or via URL with a secret key
        $is_cron = (PHP_SAPI === 'cli' || ($this->input->get('cron_key') && $this->input->get('cron_key') === $this->config->item('massmail_cron_key')));
        
        if (!$is_cron) {
            requirePermission("view");
        }

        require_once('application/libraries/ConfigEditor.php');
    }

    public function index()
    {
        $this->administrator->setTitle("Mass Mail Marketing");

        $campaigns = $this->massmail_model->getCampaigns();

        $data = [
            'url' => $this->template->page_url,
            'campaigns' => $campaigns,
            'index_path' => FCPATH . 'index.php',
            'default_emails_per_hour' => $this->config->item('massmail_default_emails_per_hour'),
            'sender_name' => $this->config->item('massmail_sender_name')
        ];

        $output = $this->template->loadPage("admin.tpl", $data);
        $content = $this->administrator->box('Mail Campaigns', $output);

        $this->administrator->view($content, false, "modules/massmail/js/admin.js?v=1.1");
    }

    public function settings()
    {
        $this->administrator->setTitle("Mass Mail Settings");

        $data = [
            'url' => $this->template->page_url,
            'default_emails_per_hour' => $this->config->item('massmail_default_emails_per_hour'),
            'sender_name' => $this->config->item('massmail_sender_name'),
            'massmail_smtp_host' => $this->config->item('massmail_smtp_host'),
            'massmail_smtp_user' => $this->config->item('massmail_smtp_user'),
            'massmail_smtp_pass' => $this->config->item('massmail_smtp_pass'),
            'massmail_smtp_port' => $this->config->item('massmail_smtp_port'),
            'massmail_smtp_crypto' => $this->config->item('massmail_smtp_crypto'),
        ];

        $output = $this->template->loadPage("settings.tpl", $data);
        $content = $this->administrator->box('Mass Mail Settings', $output);

        $this->administrator->view($content, false, "modules/massmail/js/admin.js?v=1.1");
    }

    public function log()
    {
        $this->administrator->setTitle("Mass Mail Error Log");

        $errors = $this->massmail_model->getErrors();

        $data = [
            'url' => $this->template->page_url,
            'errors' => $errors
        ];

        $output = $this->template->loadPage("log.tpl", $data);
        $content = $this->administrator->box('Mail Server Debugger', $output);

        $this->administrator->view($content);
    }

    public function clear_log()
    {
        $this->massmail_model->clearErrors();
        header('Location: ' . $this->template->page_url . 'massmail/admin/log');
        exit;
    }

    public function save_settings()
    {
        $fusionConfig = new ConfigEditor("application/config/fusion.php");

        $fusionConfig->set('massmail_default_emails_per_hour', (int)$this->input->post('default_emails_per_hour'));
        $fusionConfig->set('massmail_sender_name', $this->input->post('sender_name'));

        $fusionConfig->set('massmail_smtp_host', $this->input->post('massmail_smtp_host'));
        $fusionConfig->set('massmail_smtp_user', $this->input->post('massmail_smtp_user'));
        $fusionConfig->set('massmail_smtp_pass', $this->input->post('massmail_smtp_pass'));
        $fusionConfig->set('massmail_smtp_port', (int)$this->input->post('massmail_smtp_port'));
        $fusionConfig->set('massmail_smtp_crypto', $this->input->post('massmail_smtp_crypto'));

        $fusionConfig->save();

        header('Location: ' . $this->template->page_url . 'massmail/admin');
        exit;
    }

    public function create()
    {
        $this->administrator->setTitle("Create Campaign");

        $data = [
            'url' => $this->template->page_url,
            'default_emails_per_hour' => $this->config->item('massmail_default_emails_per_hour'),
            'sender_name' => $this->config->item('massmail_sender_name')
        ];

        $output = $this->template->loadPage("create.tpl", $data);
        $content = $this->administrator->box('New Campaign', $output);

        $this->administrator->view($content);
    }

    public function submit()
    {
        $subject = $this->input->post('subject');
        $body = $this->input->post('body');
        $emails_per_hour = $this->input->post('emails_per_hour');

        if (empty($subject) || empty($body)) {
            die("Subject and body are required.");
        }

        $target_type = $this->input->post('target_type');
        $test_emails = $this->input->post('test_emails');

        $users = [];
        if ($target_type === 'test') {
            $raw_emails = array_map('trim', explode(',', $test_emails));
            foreach ($raw_emails as $em) {
                if (!empty($em)) {
                    $users[] = [
                        'id' => 0, // Fake ID for test target
                        'email' => $em
                    ];
                }
            }
        }
        else {
            // Get all users from external account model
            $users = $this->external_account_model->getAllAccounts();
        }

        $total_users = count($users);
        if ($total_users === 0) {
            die("No valid target emails found.");
        }

        $campaign_id = $this->massmail_model->createCampaign([
            'subject' => $subject,
            'body' => $body,
            'status' => 'pending',
            'emails_per_hour' => $emails_per_hour ? $emails_per_hour : 50,
            'total_users' => $total_users,
            'sent_users' => 0,
            'created_at' => time()
        ]);

        $this->massmail_model->addToQueue($campaign_id, $users);

        header('Location: ' . $this->template->page_url . 'massmail/admin');
        exit;
    }

    public function start($id)
    {
        $this->massmail_model->updateCampaign($id, ['status' => 'sending']);
        header('Location: ' . $this->template->page_url . 'massmail/admin');
        exit;
    }

    public function pause($id)
    {
        $this->massmail_model->updateCampaign($id, ['status' => 'paused']);
        header('Location: ' . $this->template->page_url . 'massmail/admin');
        exit;
    }

    public function delete($id)
    {
        $this->massmail_model->deleteCampaign($id);
        header('Location: ' . $this->template->page_url . 'massmail/admin');
        exit;
    }

    /**
     * Cron method to process the queue.
     * Should be called via CLI or a cron job every 5-10 minutes.
     * Example: php index.php massmail admin process_queue
     */
    public function process_queue($url_key = null)
    {
        // Check secret key if not in CLI
        if (PHP_SAPI !== 'cli') {
            $key = $url_key ?: $this->input->get('cron_key');
            if (!$key || $key !== $this->config->item('massmail_cron_key')) {
                die("Unauthorized: Invalid Cron Key.");
            }
        }
        else {
            echo "Massmail Cron: Starting queue processing...\n";
        }

        $campaigns = $this->massmail_model->getPendingCampaigns();

        if (empty($campaigns)) {
            if (PHP_SAPI === 'cli') echo "Massmail Cron: No 'sending' campaigns found.\n";
            return;
        }

        // Initialize dedicated email service for massmail
        $email = $this->initEmailService();

        foreach ($campaigns as $campaign) {
            if (PHP_SAPI === 'cli') echo "Massmail Cron: Processing campaign '{$campaign['subject']}'...\n";

            // Calculate how many we can send now based on emails_per_hour
            // Assuming this cron runs every 10 minutes (6 times per hour)
            $batch_size = ceil($campaign['emails_per_hour'] / 6);

            $queue = $this->massmail_model->getQueueBatch($campaign['id'], $batch_size);

            if (empty($queue)) {
                $this->massmail_model->updateCampaign($campaign['id'], ['status' => 'completed']);
                if (PHP_SAPI === 'cli') echo "Massmail Cron: Campaign '{$campaign['subject']}' completed.\n";
                continue;
            }

            $sent_count = 0;
            $sender_name = $this->config->item('massmail_sender_name') ?: 'FusionCMS';
            $from_address = $this->config->item('massmail_smtp_user') ?: 'no-reply@localhost';

            foreach ($queue as $item) {
                // Set email data
                $email->setFrom($from_address, $sender_name);
                $email->setTo($item['email']);
                $email->setSubject($campaign['subject']);
                $email->setMessage($campaign['body']);

                if ($email->send()) {
                    $this->massmail_model->updateQueueStatus($item['id'], 'sent');
                    $sent_count++;
                }
                else {
                    $this->massmail_model->updateQueueStatus($item['id'], 'failed');
                    
                    // Log the technical error for the administrator
                    $error = $email->printDebugger(['headers']);
                    $this->massmail_model->logError($campaign['id'], $item['email'], (string)$error);
                }

                // Clear email for next iteration
                $email->clear();
            }

            $this->massmail_model->updateCampaign($campaign['id'], [
                'sent_users' => $campaign['sent_users'] + $sent_count,
                'last_batch_at' => time()
            ]);

            if (PHP_SAPI === 'cli') echo "Massmail Cron: Sent {$sent_count} emails for campaign '{$campaign['subject']}'.\n";
        }
    }

    /**
     * Initialize the email service with dedicated massmail SMTP settings
     * falling back to global settings if not defined.
     */
    private function initEmailService()
    {
        $email = \App\Config\Services::email();

        $config = [];
        $config['mailType'] = 'html';
        $config['charset'] = 'UTF-8';
        $config['newline'] = "\r\n";
        $config['CRLF'] = "\r\n";

        // Check if we have dedicated SMTP settings for massmail
        if ($this->config->item('massmail_smtp_host')) {
            $config['protocol'] = 'smtp';
            $config['SMTPHost'] = $this->config->item('massmail_smtp_host');
            $config['SMTPUser'] = $this->config->item('massmail_smtp_user');
            $config['SMTPPass'] = $this->config->item('massmail_smtp_pass');
            $config['SMTPPort'] = (int)$this->config->item('massmail_smtp_port');
            $config['SMTPCrypto'] = $this->config->item('massmail_smtp_crypto');
        } else {
            // Fallback to global SMTP
            if ($this->config->item('smtp_protocol') == 'smtp') {
                $config['protocol'] = 'smtp';
                $config['SMTPHost'] = $this->config->item('smtp_host');
                $config['SMTPUser'] = $this->config->item('smtp_user');
                $config['SMTPPass'] = $this->config->item('smtp_pass');
                $config['SMTPPort'] = (int)$this->config->item('smtp_port');
                $config['SMTPCrypto'] = $this->config->item('smtp_crypto');
            } else {
                $config['protocol'] = 'mail';
            }
        }

        $email->initialize($config);
        return $email;
    }

    /**
     * Test SMTP connection with the provided settings
     */
    public function test_smtp()
    {
        // Increase time limit for slow SMTP servers
        set_time_limit(60);

        $config = [];
        $config['mailType'] = 'html';
        $config['charset'] = 'UTF-8';
        $config['newline'] = "\r\n";
        $config['CRLF'] = "\r\n";
        $config['protocol'] = 'smtp';
        $config['SMTPHost'] = $this->input->post('massmail_smtp_host');
        $config['SMTPUser'] = $this->input->post('massmail_smtp_user');
        $config['SMTPPass'] = $this->input->post('massmail_smtp_pass');
        $config['SMTPPort'] = (int)$this->input->post('massmail_smtp_port');
        $config['SMTPCrypto'] = $this->input->post('massmail_smtp_crypto');
        $config['timeout'] = 5; // CI4 timeout
        $config['smtp_timeout'] = 5; // CI3 specific

        // Verify if we have values
        if (empty($config['SMTPHost'])) {
            die(json_encode(['status' => 0, 'msg' => 'SMTP Host is required.']));
        }

        $email = \App\Config\Services::email();
        $email->initialize($config);

        $from_email = $config['SMTPUser'] ?: 'test@localhost';
        
        $email->setFrom($from_email, 'SMTP Test');
        $email->setTo($from_email);
        $email->setSubject('Massmail SMTP Test');
        $email->setMessage('This is a test email to verify your dedicated massmail SMTP settings.');

        if ($email->send()) {
            die(json_encode(['status' => 1, 'msg' => 'SMTP connection successful! Test email sent to ' . $from_email]));
        } else {
            $error = $email->printDebugger(['headers']);
            die(json_encode(['status' => 0, 'msg' => $error]));
        }
    }
}
