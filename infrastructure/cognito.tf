resource "aws_cognito_user_pool" "user_pool" {
  name = "${var.project_name}-user-pool"

  # Define user pool settings, such as password policy, multi-factor authentication, etc.
  username_attributes      = ["email"]
  auto_verified_attributes = ["email"]

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }
}

resource "aws_cognito_user_pool_domain" "domain" {
  domain       = "sustenance"
  user_pool_id = aws_cognito_user_pool.user_pool.id
}

resource "aws_cognito_user_pool_client" "user_pool_client" {
  name         = "${var.project_name}-user-pool-client"
  user_pool_id = aws_cognito_user_pool.user_pool.id

  callback_urls                        = ["https://example.com"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["implicit"]
  allowed_oauth_scopes                 = ["email", "openid"]
  supported_identity_providers         = ["COGNITO"]
}

resource "aws_cognito_user_pool_ui_customization" "example" {
  css        = ".label-customizable {font-weight: 400;}"
  image_file = filebase64("../images/logo.png")

  user_pool_id = aws_cognito_user_pool_domain.domain.user_pool_id
}

output "cognito_domain" {
  value = "https://${aws_cognito_user_pool.user_pool.domain}.auth.ap-southeast-2.amazoncognito.com/"
}