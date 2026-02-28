<?php

namespace App\Config;

use CodeIgniter\Database\Config;

class Database extends Config
{
    public string $defaultGroup = "cms";

    public array $cms = [
        "DSN" => "",
        "hostname" => "logon.laswow.com",
        "username" => "mandioca",
        "password" => "nderasore1985",
        "database" => "webespy",
        "DBDriver" => "MySQLi",
        "DBPrefix" => "",
        "pConnect" => false,
        "DBDebug" => true,
        "charset" => "utf8mb4",
        "DBCollat" => "utf8mb4_general_ci",
        "swapPre" => "",
        "encrypt" => false,
        "compress" => false,
        "strictOn" => false,
        "failover" => [],
        "port" => 3306,
        "numberNative" => false,
        "foundRows" => false,
        "dateFormat" => [
            "date" => "Y-m-d",
            "datetime" => "Y-m-d H:i:s",
            "time" => "H:i:s",
        ],
    ];

    public array $account = [
        "DSN" => "",
        "hostname" => "playwow.esports.com.py",
        "username" => "web",
        "password" => "nderasore",
        "database" => "acore_auth",
        "DBDriver" => "MySQLi",
        "DBPrefix" => "",
        "pConnect" => false,
        "DBDebug" => false,
        "charset" => "utf8",
        "DBCollat" => "utf8_general_ci",
        "swapPre" => "",
        "encrypt" => false,
        "compress" => false,
        "strictOn" => false,
        "failover" => [],
        "port" => 3306,
        "numberNative" => false,
        "foundRows" => false,
        "dateFormat" => [
            "date" => "Y-m-d",
            "datetime" => "Y-m-d H:i:s",
            "time" => "H:i:s",
        ],
    ];
}
