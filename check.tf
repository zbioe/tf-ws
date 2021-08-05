locals {
  check_nginx_expected = "Welcome to nginx!"
}

resource "null_resource" "ws_check_http" {
  provisioner "local-exec" {
    environment = {
      IP = local.pub_ip
      EXPECTED = local.check_nginx_expected    
    }
    command = <<EOF
    bash files/curl-check.sh "$IP" "$EXPECTED" http
    EOF
  }
}

resource "null_resource" "ws_check_https" {
  provisioner "local-exec" {
    environment = {
      IP = local.pub_ip
      EXPECTED = local.check_nginx_expected
    }
    command = <<EOF
    bash files/curl-check.sh "$IP" "$EXPECTED" https
    EOF
  }
}
