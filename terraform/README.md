# 実行環境

## Mac

```sh
brew install terraform

# バージョン確認
terraform -version
Terraform v1.1.3
on darwin_arm64
```

# 実行方法

- `variables.sample.tf` を参考に `variables.tf` を作成
- `variables.sample.tf` を削除する
- `variables.tf` 内の値を入力する

```sh
terraform init

# 文法チェック
terraform plan

# 環境構築: yes と入力する
terraform apply

# 環境破壊: yes と入力する
terraform destroy
```

# Document

- https://www.linode.com/docs/guides/how-to-create-website-using-laravel/
- https://www.linode.com/docs/guides/connect-to-a-mysql-or-mariadb-database/
  - https://www.linode.com/docs/guides/installing-and-configuring-mysql-on-ubuntu-2004/
- https://www.linode.com/docs/api

## instance

### image

- https://registry.terraform.io/providers/linode/linode/latest/docs/resources/instance#image
  - https://api.linode.com/v4/images
### region

- https://registry.terraform.io/providers/linode/linode/latest/docs/resources/instance#region
  - https://api.linode.com/v4/regions

### type

- https://registry.terraform.io/providers/linode/linode/latest/docs/resources/instance#type
  - https://api.linode.com/v4/linode/types
