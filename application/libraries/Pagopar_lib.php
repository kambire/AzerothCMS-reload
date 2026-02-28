<?php

/**
 * Pagopar Payment Gateway Library for FusionCMS (CodeIgniter 4)
 * 
 * Based on the Pagopar REST API v2.0
 * Ref: https://github.com/krugerdavid/laravel-pagopar
 * Docs: https://pagopar.com/documentacion
 * 
 * API Key generation: SHA1(private_key + orderId + totalAmount)
 * Webhook verification: SHA1(private_key + hash)
 */
class Pagopar_lib
{
    protected string $baseUrl = 'https://api.pagopar.com';
    protected string $publicKey = '';
    protected string $privateKey = '';
    protected int $timeout = 30;

    /**
     * Initialize with keys from the store_payment_methods config
     */
    public function __construct(string $publicKey, string $privateKey)
    {
        $this->publicKey = $publicKey;
        $this->privateKey = $privateKey;
    }

    // ─────────────────────────────────────────
    //  TOKEN GENERATION
    // ─────────────────────────────────────────

    /**
     * Generate token for creating a payment
     * SHA1(private_key + orderId + totalAmount)
     */
    public function generatePaymentToken(string $orderId, int $totalAmountPyg): string
    {
        return sha1($this->privateKey . $orderId . $totalAmountPyg);
    }

    /**
     * Generic token: SHA1(private_key + data)
     */
    public function generateToken(string $data = ''): string
    {
        return sha1($this->privateKey . $data);
    }

    /**
     * Verify a webhook/callback token from Pagopar
     * SHA1(private_key + hash_pedido)
     */
    public function verifyWebhookToken(string $hash, string $receivedToken): bool
    {
        $expected = sha1($this->privateKey . $hash);
        return hash_equals($expected, $receivedToken);
    }

    // ─────────────────────────────────────────
    //  CHECKOUT URL
    // ─────────────────────────────────────────

    public function getCheckoutUrl(string $hash): string
    {
        return "https://www.pagopar.com/pagos/{$hash}";
    }

    // ─────────────────────────────────────────
    //  CREATE PAYMENT  (POST /api/comercios/2.0/iniciar-transaccion)
    // ─────────────────────────────────────────

    /**
     * @param string $orderId      Unique order ID from our system
     * @param string $description  Short description
     * @param int    $totalPyg     Total in Guaraníes (no decimals)
     * @param array  $buyer        Buyer data ['name','email','document','phone']
     * @param array  $items        Array of items to purchase
     * @return array ['hash' => '...', 'order_id' => '...'] or throws on failure
     * @throws \Exception
     */
    public function createPayment(
        string $orderId,
        string $description,
        int $totalPyg,
        array $buyer,
        array $items
        ): array
    {
        $token = $this->generatePaymentToken($orderId, $totalPyg);

        // Build buyer payload (Spanish field names per Pagopar API)
        $buyerPayload = [
            'nombre' => $buyer['name'] ?? '',
            'email' => $buyer['email'] ?? '',
            'documento' => $buyer['document'] ?? '1234567',
            'telefono' => $buyer['phone'] ?? '',
            'direccion' => $buyer['address'] ?? 'N/A',
            'ciudad' => $buyer['city_id'] ?? 1,
            'ruc' => $buyer['document'] ?? '1234567',
            'coordenadas' => '',
            'razon_social' => $buyer['name'] ?? '',
            'tipo_documento' => 'CI',
            'direccion_referencia' => '',
        ];

        // Build items payload
        $itemsPayload = [];
        foreach ($items as $item) {
            $itemsPayload[] = [
                'ciudad' => '1',
                'nombre' => $item['name'],
                'cantidad' => $item['quantity'] ?? 1,
                'categoria' => '909', // Digital products
                'public_key' => $this->publicKey,
                'url_imagen' => $item['image'] ?? '',
                'descripcion' => $item['description'] ?? $item['name'],
                'id_producto' => $item['id'] ?? (int)(time() % 1000000000),
                'precio_total' => (int)$item['price'] * ($item['quantity'] ?? 1),
                'vendedor_telefono' => '',
                'vendedor_direccion' => '',
                'vendedor_direccion_referencia' => '',
                'vendedor_direccion_coordenadas' => '',
            ];
        }

        $payload = [
            'token' => $token,
            'comprador' => $buyerPayload,
            'public_key' => $this->publicKey,
            'monto_total' => $totalPyg,
            'tipo_pedido' => 'FORMA-PAGO',
            'compras_items' => $itemsPayload,
            'fecha_maxima_pago' => date('Y-m-d H:i:s', strtotime('+2 days')),
            'id_pedido_comercio' => $orderId,
            'descripcion_resumen' => $description ?: "Pedido #{$orderId}",
            'forma_pago' => 1,
        ];

        $response = $this->post('/api/comercios/2.0/iniciar-transaccion', $payload);

        if (!($response['respuesta'] ?? false)) {
            $msg = $response['mensaje'] ?? 'Unknown Pagopar API error';
            log_message('error', "Pagopar createPayment failed: $msg");
            throw new \Exception("Pagopar: $msg");
        }

        $resultado = $response['resultado'] ?? [];
        return [
            'hash' => $resultado[0]['data'] ?? null,
            'order_id' => $resultado[0]['pedido'] ?? null,
            'raw' => $response,
        ];
    }

    // ─────────────────────────────────────────
    //  CHECK ORDER STATUS  (POST /api/pedidos/1.1/traer)
    // ─────────────────────────────────────────

    /**
     * Get the current status of an order by hash returned from createPayment
     * Returns the 'resultado' array; check $result[0]['pagado'] === true for success
     */
    public function getOrderStatus(string $hash): array
    {
        $token = $this->generateToken('CONSULTA');

        $response = $this->post('/api/pedidos/1.1/traer', [
            'token' => $token,
            'hash_pedido' => $hash,
            'token_publico' => $this->publicKey,
        ]);

        if (!($response['respuesta'] ?? false)) {
            log_message('error', 'Pagopar getOrderStatus returned failure: ' . json_encode($response));
            return [];
        }

        return $response['resultado'] ?? [];
    }

    // ─────────────────────────────────────────
    //  HTTP HELPER (cURL — no Guzzle needed)
    // ─────────────────────────────────────────

    private function post(string $endpoint, array $data): array
    {
        $url = $this->baseUrl . $endpoint;
        $json = json_encode($data);

        $ch = curl_init($url);
        curl_setopt_array($ch, [
            CURLOPT_POST => true,
            CURLOPT_POSTFIELDS => $json,
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_TIMEOUT => $this->timeout,
            CURLOPT_HTTPHEADER => [
                'Content-Type: application/json',
                'Accept: application/json',
                'Content-Length: ' . strlen($json),
            ],
            CURLOPT_SSL_VERIFYPEER => true,
        ]);

        $raw = curl_exec($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        $error = curl_error($ch);
        curl_close($ch);

        if ($error) {
            log_message('error', "Pagopar cURL error on $endpoint: $error");
            throw new \Exception("Network error communicating with Pagopar: $error");
        }

        $decoded = json_decode($raw, true);
        if (json_last_error() !== JSON_ERROR_NONE) {
            log_message('error', "Pagopar invalid JSON response [$httpCode]: $raw");
            throw new \Exception("Invalid response from Pagopar (HTTP $httpCode)");
        }

        return $decoded;
    }
}
