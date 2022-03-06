# 実行環境

## Mac

```sh
brew install ansible

# バージョン
ansible --version
ansible [core 2.12.1]
  config file = None
  configured module search path = ['/Users/tak/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /opt/homebrew/Cellar/ansible/5.2.0/libexec/lib/python3.10/site-packages/ansible
  ansible collection location = /Users/tak/.ansible/collections:/usr/share/ansible/collections
  executable location = /opt/homebrew/bin/ansible
  python version = 3.10.1 (main, Dec  6 2021, 22:18:13) [Clang 13.0.0 (clang-1300.0.29.3)]
  jinja version = 3.0.3
  libyaml = True
```

### Python インストール

- Ansible 実行のため、クライアントに Python 3.5 以上をインストールすること

```sh
# Python 3.9 系インストール
pipenv install
```

# ansible 実行方法

- 前提として terraform の環境作成が終わっていること
- hosts_template を元に hosts ファイルを作成すること
  - `-i` オプションでこの hosts ファイルを指定する
  - もし指定しない場合は `/etc/ansible/hosts` が利用される

```sh
# 共通設定
# 表示される公開鍵を GitHub の SSH に登録する
ansible-playbook -i hosts playbook/pb_common.yml -v

# ミドルウェアインストール
ansible-playbook -i hosts playbook/pb_middleware.yml -v

# MySQL 初期設定は対話形式なので、SSH して手動実行する
sudo mysql_secure_installation

# MySQL 初期化
# 先ほど変更した root パスワード、および作成する DB 名を ansible/roles/mysql/vars/main.yml に反映する
ansible-playbook -i hosts playbook/pb_mysql.yml -v

# SSH して手動で git clone 実行
cd /var/www
git clone git@github.com:EeeeG-Inc/OKR-manage-app.git
cd OKR-manage-app
chmod 777 storage
chmod 777 storage/app/public/profiles

# nginx 初期化
# ansible/roles/nginx/files/config の root 名 / php-fpm.sock のバージョンが合っているか確認すること
ansible-playbook -i hosts playbook/pb_nginx.yml -v
```

## 修正が必要になる可能性があるファイルまとめ

- `ansible/roles/mysql/vars/main.yml`
- `ansible/roles/nginx/vars/main.yml`
- `ansible/roles/nginx/files/config`

# Document

- apt
  - https://docs.ansible.com/ansible/2.4/apt_module.html
