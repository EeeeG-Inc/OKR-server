# Linode に Laravel 動作環境を構築する

- ubuntu 21.10
  - Linode の nanode インスタンスタイプで構築
- Laravel Framework 8.75.0
- PHP 7.3.33
- MySQL 8.0.27

# Terraform

## 下記 README.md の手順を実施

- https://github.com/EeeeG-Inc/OKR-server/tree/main/terraform

## SSH

Linode インスタンス構築後の作業

```sh
# クライアントの公開鍵を転送する
scp ~/.ssh/id_rsa.pub root@IP:~/.ssh/authorized_keys
```

### クライアントの ~/.ssh/config

```
Host okr-web
    HostName IP
    User root
    IdentityFile ~/.ssh/id_rsa
```

```sh
# 以下コマンドで SSH 可能になる
ssh okr-web
```

# Ansible

## 下記 README.md の手順を実施

- https://github.com/EeeeG-Inc/OKR-server/tree/main/ansible

# Laravel の作業

```sh
cd /var/www/OKR-manage-app
cp .env.example .env
vi .env
```

- `.env` を編集する

```
DB_CONNECTION=mysql
DB_HOST=localhost
DB_PORT=3306
DB_DATABASE=データベース
DB_USERNAME=ユーザ
DB_PASSWORD=パスワード
```

```sh
# php7.3 であることを確認
php -v

# PHP バージョンが違う場合、このコマンドで変更する
# update-alternatives --config php

composer install
php artisan key:gen
php artisan migrate --seed
npm i
npm run dev

# nginx 再起動
systemctl restart nginx
```
