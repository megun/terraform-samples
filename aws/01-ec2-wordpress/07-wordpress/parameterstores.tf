### AUTH_KEY
resource "random_password" "auth_key" {
  length = 64
}

resource "aws_ssm_parameter" "auth_key" {
  name  = "/${var.project}/${var.env}/wordpress/auth_key"
  type  = "SecureString"
  value = random_password.auth_key.result

  lifecycle {
    ignore_changes = [value]
  }
}

### SECURE_AUTH_KEY
resource "random_password" "secure_auth_key" {
  length = 64
}

resource "aws_ssm_parameter" "secure_auth_key" {
  name  = "/${var.project}/${var.env}/wordpress/secure_auth_key"
  type  = "SecureString"
  value = random_password.secure_auth_key.result

  lifecycle {
    ignore_changes = [value]
  }
}

### LOGGED_IN_KEY
resource "random_password" "logged_in_key" {
  length = 64
}

resource "aws_ssm_parameter" "logged_in_key" {
  name  = "/${var.project}/${var.env}/wordpress/logged_in_key"
  type  = "SecureString"
  value = random_password.logged_in_key.result

  lifecycle {
    ignore_changes = [value]
  }
}

### NONCE_KEY
resource "random_password" "nonce_key" {
  length = 64
}

resource "aws_ssm_parameter" "nonce_key" {
  name  = "/${var.project}/${var.env}/wordpress/nonce_key"
  type  = "SecureString"
  value = random_password.nonce_key.result

  lifecycle {
    ignore_changes = [value]
  }
}

### AUTH_SALT
resource "random_password" "auth_salt" {
  length = 64
}

resource "aws_ssm_parameter" "auth_salt" {
  name  = "/${var.project}/${var.env}/wordpress/auth_salt"
  type  = "SecureString"
  value = random_password.auth_salt.result

  lifecycle {
    ignore_changes = [value]
  }
}

### SECURE_AUTH_SALT
resource "random_password" "secure_auth_salt" {
  length = 64
}

resource "aws_ssm_parameter" "secure_auth_salt" {
  name  = "/${var.project}/${var.env}/wordpress/secure_auth_salt"
  type  = "SecureString"
  value = random_password.secure_auth_salt.result

  lifecycle {
    ignore_changes = [value]
  }
}

### LOGGED_IN_SALT
resource "random_password" "logged_in_salt" {
  length = 64
}

resource "aws_ssm_parameter" "logged_in_salt" {
  name  = "/${var.project}/${var.env}/wordpress/logged_in_salt"
  type  = "SecureString"
  value = random_password.logged_in_salt.result

  lifecycle {
    ignore_changes = [value]
  }
}

### NONCE_SALT
resource "random_password" "nonce_salt" {
  length = 64
}

resource "aws_ssm_parameter" "nonce_salt" {
  name  = "/${var.project}/${var.env}/wordpress/nonce_salt"
  type  = "SecureString"
  value = random_password.nonce_salt.result

  lifecycle {
    ignore_changes = [value]
  }
}
