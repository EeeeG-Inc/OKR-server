# 実行環境

## Mac

```sh
brew install ansible
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

```sh
# 共通設定
ansible-playbook -i hosts playbook/pb_common.yml -v

# ミドルウェアインストール
# -i オプションで hosts ファイルを指定: 指定しない場合は /etc/ansible/hosts が利用される
ansible-playbook -i hosts playbook/pb_middleware.yml -v

# MySQL 初期設定は対話形式なので、手動実行
# 変更したパスワードは ansible/roles/mysql/vars/main.yml に反映する
sudo mysql_secure_installation

# MySQL 初期化
ansible-playbook -i hosts playbook/pb_mysql.yml -v

# 表示される公開鍵を GitHub の SSH に登録する
ansible-playbook -i hosts playbook/pb_ssh-keygen.yml -v

cd /var/www
git clone git@github.com:EeeeG-Inc/OKR-manage-app.git
cd OKR-manage-app
chmod 777 storage

# nginx 初期化
# ansible/roles/nginx/files/config の root 名 / php-fpm.sock のバージョンが合っているか確認すること
ansible-playbook -i hosts playbook/pb_nginx.yml -v
```

# 参考

- https://docs.ansible.com/ansible/2.4/apt_module.html
