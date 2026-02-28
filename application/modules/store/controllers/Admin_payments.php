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
            $id = $this->input->post('id');
            $active = $this->input->post('is_active') ? 1 : 0;
            $config = $this->input->post('config');

            if ($id && $config) {
                $this->store_model->updatePaymentMethod((int)$id, $active, trim($config));
                // Use CI4 Services session for flash messages (framework pattern)
                Services::session()->setTempdata('pay_success', 'Payment gateway settings saved.', 5);
            }

            redirect($this->template->page_url . "store/admin_payments");
        }

        $gateways = $this->store_model->getPaymentMethods();
        $success_msg = Services::session()->getTempdata('pay_success');

        $data = [
            'gateways' => $gateways ?: [],
            'url' => $this->template->page_url,
            'success_msg' => $success_msg,
        ];

        $output = $this->template->loadPage("admin_payments.tpl", $data);
        $content = $this->administrator->box('Payment Gateways Settings', $output);
        $this->administrator->view($content, false, false);
    }
}
