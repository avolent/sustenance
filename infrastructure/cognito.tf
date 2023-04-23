resource "aws_cognito_user_pool" "user_pool" {
  name = "${var.project_name}-user-pool"

  # Define user pool settings, such as password policy, multi-factor authentication, etc.
}

resource "aws_cognito_user_pool_domain" "domain" {
  domain       = "sustenance"
  user_pool_id = aws_cognito_user_pool.user_pool.id
}

resource "aws_cognito_user_pool_client" "user_client" {
  name         = "${var.project_name}-user-pool-client"
  user_pool_id = aws_cognito_user_pool.user_pool.id

  # Define the settings for the user pool client
  explicit_auth_flows = ["ADMIN_NO_SRP_AUTH"]

  # Define the allowed OAuth flows and scopes for the user pool client
  allowed_oauth_flows  = ["code"]
  allowed_oauth_scopes = ["email", "openid"]

  # Define the callback URLs and logout URLs for the user pool client
  callback_urls = ["https://example.com/callback"]
  logout_urls   = ["https://example.com/logout"]

  # Enable the user pool client for the user pool UI
  prevent_user_existence_errors = "ENABLED"
}

resource "aws_cognito_user_pool_ui_customization" "example" {
  css        = ".label-customizable {font-weight: 400;}"
  image_file = filebase64("../images/logo.png")

  user_pool_id = aws_cognito_user_pool_domain.domain.user_pool_id
}