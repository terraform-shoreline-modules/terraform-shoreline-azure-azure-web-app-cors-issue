resource "shoreline_notebook" "azure_web_app_cors_issue" {
  name       = "azure_web_app_cors_issue"
  data       = file("${path.module}/data/azure_web_app_cors_issue.json")
  depends_on = [shoreline_action.invoke_cors_header_update]
}

resource "shoreline_file" "cors_header_update" {
  name             = "cors_header_update"
  input_file       = "${path.module}/data/cors_header_update.sh"
  md5              = filemd5("${path.module}/data/cors_header_update.sh")
  description      = "Update and ensure that the correct headers are being set. Specifically, the Access-Control-Allow-Origin header should be set to allow requests from the client's domain."
  destination_path = "/tmp/cors_header_update.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_cors_header_update" {
  name        = "invoke_cors_header_update"
  description = "Update and ensure that the correct headers are being set. Specifically, the Access-Control-Allow-Origin header should be set to allow requests from the client's domain."
  command     = "`chmod +x /tmp/cors_header_update.sh && /tmp/cors_header_update.sh`"
  params      = ["CLIENT_DOMAIN","WEB_APP_NAME","RESOURCE_GROUP_NAME"]
  file_deps   = ["cors_header_update"]
  enabled     = true
  depends_on  = [shoreline_file.cors_header_update]
}

