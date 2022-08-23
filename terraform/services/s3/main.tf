module "logs" {
  source = "../../elements/s3/bucket"

  bucket_name = "logs.graduation-thesis.bs219031.sun.ac.jp"
  bucket_acl  = "private"
}
