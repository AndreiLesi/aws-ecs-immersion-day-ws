locals {
  region = "eu-central-1"
  project_name = "ECSImmersionDay"
  environment_variables = {
    ENDPOINTS_CATALOG  = "http://google.com"
    ENDPOINTS_CARTS    = "http://google.com"
    ENDPOINTS_CHECKOUT = "http://google.com"
    ENDPOINTS_ORDERS   = "http://google.com"
    ENDPOINTS_ASSETS   = "http://google.com"
  }   
}