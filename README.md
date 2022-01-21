# Linode

## SSH

インスタンス構築後の作業

```sh
# クライアントの公開鍵を転送する
# eeeeg-okr-app-2022!
scp ~/.ssh/id_rsa.pub root@172.104.89.181:~/.ssh/authorized_keys

# eeeeg-okr-app-2022!
ssh root@172.104.89.181

chmod 600 ~/.ssh/authorized_keys

# PasswordAuthentication を no にして restart
vi /etc/ssh/sshd_config
/etc/init.d/ssh restart
```

この設定をしておくと、ローカルの公開鍵を見るようになるのでパスワード入力が不要になる

### ローカルの ~/.ssh/config について

```
Host okr-web
    HostName 172.104.89.181
    User root
    IdentityFile ~/.ssh/id_rsa
```

```sh
# 以下コマンドで SSH 可能になる
ssh okr-web
```

### やること

```sh
# 公開鍵作成: GitHub に登録
cd ~/.ssh
ssh-keygen -m pem
cat ~/.ssh/id_rsa.pub
vi ~/.ssh/authorized_keys

sudo apt update -y && sudo apt upgrade -y

# リポジトリを追加
sudo add-apt-repository ppa:ondrej/php
sudo apt-add-repository ppa:ansible/ansible

# php 7.3 系をインストール
sudo apt install php7.3 php7.3-bcmath php7.3-curl php7.3-json php7.3-mbstring php7.3-mysql php7.3-xml php7.3-zip php7.3-fpm -y

# MySQL をインストール: MySQL 8 系
sudo apt install mysql-client mysql-server -y

# その他、ミドルウェアをインストール
sudo apt install ansible git nginx openssl emacs npm -y

cd ~

# composer をインストール
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
sudo chmod +x /usr/local/bin/composer

php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === '756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php

# ディレクトリ作成
mkdir -p /var/www
cd /var/www

# MySQL
sudo mysql_secure_installation

mysql -u root -proot

# plugin が auth_socket になっていたら mysql_native_password に変更する: これをしていないとパスワードログインできない
SELECT user,authentication_string,plugin,host FROM mysql.user;

# ポリシーを満たす password 変更と mysql_native_password に変更
ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'password';

FLUSH PRIVILEGES;

CREATE DATABASE okr;

# すべての IP アクセスから DB アクセス許可
emacs /etc/mysql/mysql.conf.d/mysqld.cnf
```

```
# 下記修正
bind-address = 0.0.0.0
```

```sh
sudo systemctl restart mysql.service

# git clone
git clone git@github.com:EeeeG-Inc/OKR-manage-app.git
cd OKR-manage-app
chmod -R 777 storage
cp .env.example .env
emacs .env
```

```
DB_CONNECTION=mysql
DB_HOST=localhost
DB_PORT=3306
DB_DATABASE=okr
DB_USERNAME=root
DB_PASSWORD=root
```

```sh
# おそらく最初は php7.3 というコマンドでしか動かない
php -v

# PHP バージョンが違う場合、このコマンドで変更する
update-alternatives --config php

php -v

composer install
php artisan key:gen
php artisan migrate --seed
npm i
npm run dev

# Apache が起動している場合は停止
sudo service apache2 stop

# nginx
sudo chown -R www-data.www-data /var/www/OKR-manage-app/storage

emacs /etc/nginx/sites-available/OKR-manage-app
```

```
server {
    listen 80 default_server;
    root /var/www/OKR-manage-app/public;

    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-Content-Type-Options "nosniff";

    index index.php;

    charset utf-8;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    error_page 404 /index.php;

    location ~ \.php$ {
        fastcgi_pass unix:/var/run/php/php7.3-fpm.sock;
        fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
        include fastcgi_params;
    }

    location ~ /\.(?!well-known).* {
        deny all;
    }
}
```

```sh
sudo ln -s /etc/nginx/sites-available/OKR-manage-app /etc/nginx/sites-enabled/
sudo rm /etc/nginx/sites-enabled/default

# 文法チェック
sudo nginx -t

# nginx 起動
sudo systemctl enable nginx
sudo systemctl start nginx

# 再起動する場合
sudo systemctl restart nginx

# php-fpm 起動
sudo systemctl enable php7.3-fpm
sudo systemctl start php7.3-fpm

# 再起動する場合
sudo systemctl restart php7.3-fpm
```
