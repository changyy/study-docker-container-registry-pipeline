# Study Deploy Docker to AWS ECS

使用 PHP Laravel framework 開發和維運

環境:

- PHP8.4
- Laravel v11

# 環境安裝

## Laravel 官方推薦的安裝法：

https://laravel.com/docs/11.x/installation#creating-a-laravel-project

### PHP 等工具安裝

macos:

```bash
/bin/bash -c "$(curl -fsSL https://php.new/install/mac/8.4)"
```

windows:

```bash
# Run as administrator...
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://php.new/install/windows/8.4'))
```

linux: 

```bash
/bin/bash -c "$(curl -fsSL https://php.new/install/linux/8.4)"
```

# 專案初始化

```bash
% sw_vers 
ProductName:		macOS
ProductVersion:		15.3
BuildVersion:		24D60
% php -v
PHP 8.4.1 (cli) (built: Nov 21 2024 08:58:37) (NTS)
Copyright (c) The PHP Group
Zend Engine v4.4.1, Copyright (c) Zend Technologies
    with Zend OPcache v8.4.1, Copyright (c), by Zend Technologies
% laravel --version
Laravel Installer 5.10.0
```

```bash
% laravel new www  

   _                               _
  | |                             | |
  | |     __ _ _ __ __ ___   _____| |
  | |    / _` | '__/ _` \ \ / / _ \ |
  | |___| (_| | | | (_| |\ V /  __/ |
  |______\__,_|_|  \__,_| \_/ \___|_|


 ┌ Would you like to install a starter kit? ────────────────────┐
 │ No starter kit                                               │
 └──────────────────────────────────────────────────────────────┘

 ┌ Which testing framework do you prefer? ──────────────────────┐
 │ Pest                                                         │
 └──────────────────────────────────────────────────────────────┘

Creating a "laravel/laravel" project at "./www"
Installing laravel/laravel (v11.6.1)
  - Downloading laravel/laravel (v11.6.1)
  - Installing laravel/laravel (v11.6.1): Extracting archive
...
No security vulnerability advisories found.
> @php -r "file_exists('.env') || copy('.env.example', '.env');"

   INFO  Application key set successfully.  

 ┌ Which database will your application use? ───────────────────┐
 │ SQLite                                                       │
 └──────────────────────────────────────────────────────────────┘

 ┌ Would you like to run the default database migrations? ──────┐
 │ Yes                                                          │
 └──────────────────────────────────────────────────────────────┘


   INFO  Preparing database.  

  Creating migration table ............................................................................................................. 2.89ms DONE

   INFO  Running migrations.  

  0001_01_01_000000_create_users_table ................................................................................................. 2.54ms DONE
  0001_01_01_000001_create_cache_table ................................................................................................. 0.75ms DONE
  0001_01_01_000002_create_jobs_table .................................................................................................. 1.92ms DONE

./composer.json has been updated
Using version ^3.7 for pestphp/pest
Using version ^3.1 for pestphp/pest-plugin-laravel
...
Generating optimized autoload files
> Illuminate\Foundation\ComposerScripts::postAutoloadDump
> @php artisan package:discover --ansi

   INFO  Discovering packages.  

  laravel/pail ................................................................................................................................ DONE
  laravel/sail ................................................................................................................................ DONE
  laravel/tinker .............................................................................................................................. DONE
  nesbot/carbon ............................................................................................................................... DONE
  nunomaduro/collision ........................................................................................................................ DONE
  nunomaduro/termwind ......................................................................................................................... DONE
  pestphp/pest-plugin-laravel ................................................................................................................. DONE

88 packages you are using are looking for funding.
Use the `composer fund` command to find out more!
> @php artisan vendor:publish --tag=laravel-assets --ansi --force

   INFO  No publishable resources for tag [laravel-assets].  

No security vulnerability advisories found.

   INFO  Preparing tests directory.

  phpunit.xml ................................................................................................................. File already exists.  
  tests/Pest.php ..................................................................................................................... File created.  
  tests/TestCase.php .......................................................................................................... File already exists.  
  tests/Unit/ExampleTest.php .................................................................................................. File already exists.  
  tests/Feature/ExampleTest.php ............................................................................................... File already exists.  

   INFO  Application ready in [www]. You can start your local development using:

➜ cd www
➜ npm install && npm run build
➜ composer run dev

  New to Laravel? Check out our bootcamp and documentation. Build something amazing!
```

# 專案本地開發

## macos 本地環境

```bash
% node -v
v22.9.0
% npm -v
10.8.3
% php -v
PHP 8.4.1 (cli) (built: Nov 21 2024 08:58:37) (NTS)
Copyright (c) The PHP Group
Zend Engine v4.4.1, Copyright (c) Zend Technologies
    with Zend OPcache v8.4.1, Copyright (c), by Zend Technologies
% composer -V
Composer version 2.8.3 2024-11-17 13:13:04
PHP version 8.4.1 (/Users/user/.config/herd-lite/bin/php)
Run the "diagnose" command to get more detailed diagnostics output.
```

## 運行

```bash
% cd www
% npm install && npm run build
% npm install && npm run build

added 163 packages, and audited 164 packages in 15s

40 packages are looking for funding
  run `npm fund` for details

found 0 vulnerabilities

> build
> vite build

vite v6.1.0 building for production...
✓ 53 modules transformed.
public/build/manifest.json             0.27 kB │ gzip:  0.15 kB
public/build/assets/app-CJ70LGK8.css  19.38 kB │ gzip:  4.09 kB
public/build/assets/app-CqflisoM.js   35.09 kB │ gzip: 14.13 kB
✓ built in 350ms

% composer run dev
> Composer\Config::disableProcessTimeout
> npx concurrently -c "#93c5fd,#c4b5fd,#fb7185,#fdba74" "php artisan serve" "php artisan queue:listen --tries=1" "php artisan pail --timeout=0" "npm run dev" --names=server,queue,logs,vite
[vite] 
[vite] > dev
[vite] > vite
[vite] 
[queue] 
[queue]    INFO  Processing jobs from the [default] queue.  
[queue] 
[logs] 
[logs]    INFO  Tailing application logs.                        Press Ctrl+C to exit  
[logs]                                                Use -v|-vv to show more details  
[vite] 
[vite]   VITE v6.1.0  ready in 111 ms
[vite] 
[vite]   ➜  Local:   http://localhost:5173/
[vite]   ➜  Network: use --host to expose
[vite] 
[vite]   LARAVEL v11.41.3  plugin v1.2.0
[vite] 
[vite]   ➜  APP_URL: http://localhost
[server] 
[server]    INFO  Server running on [http://127.0.0.1:8000].  
[server] 
[server]   Press Ctrl+C to stop the server
[server] 
```

此時瀏覽 `http://127.0.0.1:8000` 可以看到網站尾顯示 `Laravel v11.41.3 (PHP v8.4.1)`

---

## Docker Image

建立本地 image

```bash
% pwd
% tree -L 2
.
├── README.md
├── docker
│   ├── nginx
│   └── php-fpm
└── www
    ├── README.md
    ├── app
    ├── artisan
    ├── bootstrap
    ├── composer.json
    ├── composer.lock
    ├── config
    ├── database
    ├── node_modules
    ├── package-lock.json
    ├── package.json
    ├── phpunit.xml
    ├── postcss.config.js
    ├── public
    ├── resources
    ├── routes
    ├── storage
    ├── tailwind.config.js
    ├── tests
    ├── vendor
    └── vite.config.js

16 directories, 11 files
```

### 編譯 Docker Image - PHP-FPM

```bash
% docker build -t my-laravel-app:latest -f docker/php-fpm/Dockerfile .
```

在 macOS 環境中，單測此 Docker Image - PHP-FPM

```bash
% docker run -d --name php-test -p 9000:9000 my-laravel-app:latest
```

使用 gtelnet 測試:

```bash
% gtelnet localhost 9000
Trying 127.0.0.1...
Connected to localhost.
Escape character is '^]'.
^CConnection closed by foreign host.
```

使用 curl 測試:

```bash
% curl -i -H 'FastCGI-Params: REQUEST_METHOD=GET' http://127.0.0.1:9000/ 
curl: (52) Empty reply from server
```

進入容器內測試: 

```bash
% docker exec -it php-test bash
root@1bdb79495720:/var/www/html# which php
/usr/local/bin/php
root@d58f73dd4d66:/var/www/html# php -v
PHP 8.4.3 (cli) (built: Feb  4 2025 05:50:29) (NTS)
Copyright (c) The PHP Group
Built by https://github.com/docker-library/php
Zend Engine v4.4.3, Copyright (c) Zend Technologies
    with Zend OPcache v8.4.3, Copyright (c), by Zend Technologies
root@d58f73dd4d66:/var/www/html# php -m
[PHP Modules]
bcmath
Core
ctype
curl
date
dom
exif
fileinfo
filter
gd
hash
iconv
json
libxml
mbstring
mysqlnd
openssl
pcntl
pcre
PDO
pdo_mysql
pdo_sqlite
Phar
posix
random
readline
Reflection
session
SimpleXML
sodium
SPL
sqlite3
standard
tokenizer
xml
xmlreader
xmlwriter
Zend OPcache
zlib

[Zend Modules]
Zend OPcache
```

停止容器:

```bash
% docker stop php-test
```

刪除容器:

```bash
% docker rm php-test
```

---

## 使用 Docker Compose 在本機端運行

```bash
% tree docker 
docker
├── docker-compose.yml
├── nginx
│   ├── Dockerfile
│   ├── docker-entrypoint.sh
│   └── templates
│       └── app.conf.template
└── php-fpm
    ├── Dockerfile
    ├── php.ini
    └── www.conf

4 directories, 7 files

% docker-compose -f docker/docker-compose.yml up --build
...
[+] Running 4/4
 ✔ nginx                       Built                                                           0.0s 
 ✔ php-fpm                     Built                                                           0.0s 
 ✔ Container docker-php-fpm-1  Created                                                         0.0s 
 ✔ Container docker-nginx-1    Created                                                         0.0s 
Attaching to nginx-1, php-fpm-1
php-fpm-1  | [10-Feb-2025 09:00:19] NOTICE: fpm is running, pid 1
php-fpm-1  | [10-Feb-2025 09:00:19] NOTICE: ready to handle connections
nginx-1    | 2025/02/10 09:00:19 [notice] 1#1: using the "epoll" event method
nginx-1    | 2025/02/10 09:00:19 [notice] 1#1: nginx/1.27.4
nginx-1    | 2025/02/10 09:00:19 [notice] 1#1: built by gcc 14.2.0 (Alpine 14.2.0) 
nginx-1    | 2025/02/10 09:00:19 [notice] 1#1: OS: Linux 6.12.5-linuxkit
nginx-1    | 2025/02/10 09:00:19 [notice] 1#1: getrlimit(RLIMIT_NOFILE): 1048576:1048576
nginx-1    | 2025/02/10 09:00:19 [notice] 1#1: start worker processes
nginx-1    | 2025/02/10 09:00:19 [notice] 1#1: start worker process 8
nginx-1    | 2025/02/10 09:00:19 [notice] 1#1: start worker process 9
nginx-1    | 2025/02/10 09:00:19 [notice] 1#1: start worker process 10
nginx-1    | 2025/02/10 09:00:19 [notice] 1#1: start worker process 11


v View in Docker Desktop   o View Config   w Enable Watch

```
