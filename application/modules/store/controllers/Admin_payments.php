<?php

use MX\MX_Controller;

class Admin_payments extends MX_Controller
{
    public function __construct()
    {
        $this->load->library('administrator');
        $this->load->model('store_model');

        parent::__construct();

        requirePermission("hasManagementAccess");
    }

    public function index()
    {
        $this->administrator->setTitle("Payment Gateways");

        if ($this->input->post()) {
            $id = $this->input->post('id');
            $is_active = $this->input->post('is_active') ? 1 : 0;
            $config = $this->input->post('config');

            if ($id && $config) {
                // Config should be a json string, ensure at least it's a valid string format
                $this->store_model->updatePaymentMethod($id, $is_active, trim($config));
                $this->session->setFlashdata('success', 'Payment gateway settings saved successfully.');
            }
            redirect($this->template->page_url . "store/admin_payments");
        }

        $gateways = $this->store_model->getPaymentMethods();

        $data = array(
            'gateways' => $gateways,
            'url' => $this->template->page_url,
            'success_msg' => $this->session->getFlashdata('success')
        );

        $output = $this->template->loadPage("admin_payments.tpl", $data);

        $content = $this->administrator->box('Payment Gateways Settings', $output);
        $this->administrator->view($content, false, false);
    }
}
