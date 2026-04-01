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

        $this->administrator->view($content, false, "modules/massmail/js/admin.js");
    }

    public function settings()
    {
        $this->administrator->setTitle("Mass Mail Settings");

        $data = [
            'url' => $this->template->page_url,
            'default_emails_per_hour' => $this->config->item('massmail_default_emails_per_hour'),
            'sender_name' => $this->config->item('massmail_sender_name')
        ];

        $output = $this->template->loadPage("settings.tpl", $data);
        $content = $this->administrator->box('Mass Mail Settings', $output);

        $this->administrator->view($content);
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

        $campaigns = $this->massmail_model->getPendingCampaigns();

        foreach ($campaigns as $campaign) {
            // Calculate how many we can send now based on emails_per_hour
            // Assuming this cron runs every 10 minutes (6 times per hour)
            $batch_size = ceil($campaign['emails_per_hour'] / 6);

            $queue = $this->massmail_model->getQueueBatch($campaign['id'], $batch_size);

            if (empty($queue)) {
                $this->massmail_model->updateCampaign($campaign['id'], ['status' => 'completed']);
                continue;
            }

            $sent_count = 0;
            foreach ($queue as $item) {
                $status = sendMail($item['email'], $campaign['subject'], 'User', $campaign['body'], 0);

                if ($status === true) {
                    $this->massmail_model->updateQueueStatus($item['id'], 'sent');
                    $sent_count++;
                }
                else {
                    $this->massmail_model->updateQueueStatus($item['id'], 'failed');
                    
                    // Log the technical error for the administrator
                    $this->massmail_model->logError($campaign['id'], $item['email'], (string)$status);
                }
            }

            $this->massmail_model->updateCampaign($campaign['id'], [
                'sent_users' => $campaign['sent_users'] + $sent_count,
                'last_batch_at' => time()
            ]);
        }
    }
}
