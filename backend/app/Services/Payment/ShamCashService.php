<?php

namespace App\Services\Payment;

use Illuminate\Support\Facades\Http;

class ShamCashService
{
    protected string $baseUrl;
    protected string $token;

    public function __construct()
    {
        $this->baseUrl = config('services.shamcash.base_url');
        $this->token = config('services.shamcash.token');
    }

    protected function request(string $endpoint, array $params = [])
    {
        $response = Http::withToken($this->token)
            ->acceptJson()
            ->get(
                $this->baseUrl . $endpoint,
                $params
            );

        $data = $response->json();

        if (
            !$response->successful()
            || ($data['status'] ?? null) !== 'success'
        ) {
            throw new \Exception(
                $data['message'] ?? 'ShamCash Error'
            );
        }

        return $data['data'];
    }

    public function accounts()
    {
        return $this->request('/accounts');
    }

    public function transactions(array $params = [])
    {
        return $this->request(
            '/transactions',
            $params
        );
    }
}
