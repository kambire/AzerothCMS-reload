<?php

class Massmail_model extends CI_Model
{
    public function __construct()
    {
        parent::__construct();
    }

    public function getCampaigns()
    {
        $query = $this->db->query("SELECT * FROM mail_campaigns ORDER BY id DESC");
        return $query->getResultArray();
    }

    public function getCampaign($id)
    {
        $query = $this->db->query("SELECT * FROM mail_campaigns WHERE id = ?", [$id]);
        return $query->getRowArray();
    }

    public function createCampaign($data)
    {
        $this->db->table('mail_campaigns')->insert($data);
        return $this->db->insertID();
    }

    public function updateCampaign($id, $data)
    {
        $this->db->table('mail_campaigns')->where('id', $id)->update($data);
    }

    public function deleteCampaign($id)
    {
        $this->db->table('mail_campaigns')->where('id', $id)->delete();
        $this->db->table('mail_queue')->where('campaign_id', $id)->delete();
    }

    public function addToQueue($campaign_id, $users)
    {
        $data = [];
        foreach ($users as $user) {
            $data[] = [
                'campaign_id' => $campaign_id,
                'user_id' => $user['id'],
                'email' => $user['email'],
                'status' => 'pending'
            ];

            // Insert in batches of 100 to avoid huge queries
            if (count($data) >= 100) {
                $this->db->table('mail_queue')->insertBatch($data);
                $data = [];
            }
        }

        if (!empty($data)) {
            $this->db->table('mail_queue')->insertBatch($data);
        }
    }

    public function getQueueBatch($campaign_id, $limit)
    {
        $query = $this->db->query("SELECT * FROM mail_queue WHERE campaign_id = ? AND status = 'pending' LIMIT ?", [$campaign_id, (int)$limit]);
        return $query->getResultArray();
    }

    public function updateQueueStatus($id, $status)
    {
        $this->db->table('mail_queue')->where('id', $id)->update([
            'status' => $status,
            'sent_at' => time()
        ]);
    }

    public function getPendingCampaigns()
    {
        $query = $this->db->query("SELECT * FROM mail_campaigns WHERE status = 'sending'");
        return $query->getResultArray();
    }
}
