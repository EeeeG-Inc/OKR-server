variable "linode" {
  default = {
    # Linode の API Token
    token = ""
  }
}

variable "linode_instance" {
  default = {
    # クライアントの公開鍵
    authorized_keys = ""
    # root ユーザのパスワード設定 (脆弱だとエラー)
    root_pass = ""
  }
}
