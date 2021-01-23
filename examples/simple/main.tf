module "simple" {
  source = "../.."

  name        = "example"
  environment = "test"
  vpc_cidr    = "10.200.0.0/16"
  zone_ids    = ["use2-az1", "use2-az2", "use2-az3"]
}
