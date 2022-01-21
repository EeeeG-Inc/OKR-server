terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
    }
  }
}

provider "linode" {
  # linode の API トークン
  token = "${var.linode.token}"
}

resource "linode_instance" "okr" {
  image = "linode/ubuntu21.10"
  label = "OKR-web"
  group = "OKR"
  # 東京リージョン
  region = "ap-northeast"
  # とりあえず一番しょぼいインスタンスタイプ
  type = "g6-nanode-1"
  authorized_keys = [ "${var.linode_instance.authorized_keys}" ]
  root_pass = "${var.linode_instance.root_pass}"
}
