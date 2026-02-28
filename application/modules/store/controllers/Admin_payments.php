<?php

use App\Config\Services;
use MX\MX_Controller;

class Admin_payments extends MX_Controller
{
    public function __construct()
    {
        $this->load->library('administrator');
        $this->load->model('store_model');
        parent::__construct();
        requirePermission("canViewOrders");
    }

    public function index()
    {
        $this->administrator->setTitle("Payment Gateways");

        if ($this->input->post()) {
            $id = (int)$this->input->post('id');
            $active = $this->input->post('is_active') ? 1 : 0;
            $name = $this->input->post('gateway_name');
            $config = $this->buildConfig($name);

            if ($id && $config !== false) {
                $this->store_model->updatePaymentMethod($id, $active, $config);
                Services::session()->setTempdata('pay_success', 'Settings saved successfully!', 5);
            }

            redirect($this->template->page_url . "store/admin_payments");
        }

        $rawGateways = $this->store_model->getPaymentMethods();
        $gateways = [];
        foreach ($rawGateways as $gw) {
            $gw['config_parsed'] = json_decode($gw['config'], true) ?: [];
            $gateways[] = $gw;
        }

        $data = [
            'gateways' => $gateways,
            'url' => $this->template->page_url,
            'success_msg' => Services::session()->getTempdata('pay_success'),
        ];

        $output = $this->template->loadPage("admin_payments.tpl", $data);
        $content = $this->administrator->box('Payment Gateways Settings', $output);
        $this->administrator->view($content, false, false);
    }

    /**
     * Build the JSON config from structured POST fields per gateway type
     */
    private function buildConfig(string $name): string|false
    {
        switch ($name) {
            case 'offline':
                $config = [
                    'beneficiary' => $this->input->post('beneficiary', true),
                    'bank_name' => $this->input->post('bank_name', true),
                    'account_number' => $this->input->post('account_number', true),
                    'account_type' => $this->input->post('account_type', true),
                    'currency' => $this->input->post('currency', true),
                    'pix_key' => $this->input->post('pix_key', true),
                    'instructions' => $this->input->post('instructions', true),
                ];
                break;

            case 'paypal':
                $config = [
                    'client_id' => $this->input->post('client_id', true),
                    'secret' => $this->input->post('secret', true),
                    'mode' => $this->input->post('mode', true) === 'live' ? 'live' : 'sandbox',
                    'currency' => $this->input->post('currency', true) ?: 'USD',
                ];
                break;

            case 'pagopar':
                $config = [
                    'public_key' => $this->input->post('public_key', true),
                    'private_key' => $this->input->post('private_key', true),
                    'currency' => 'PYG',
                ];
                break;

            case 'skrill':
                $config = [
                    'merchant_email' => $this->input->post('merchant_email', true),
                    'secret_word' => $this->input->post('secret_word', true),
                    'currency' => $this->input->post('currency', true) ?: 'USD',
                ];
                break;

            default:
                // Generic: save any extra JSON they typed
                $config = [];
        }

        return json_encode($config, JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT);
    }
}
