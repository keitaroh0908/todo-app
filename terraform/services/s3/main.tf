module "logs" {
  source = "../../elements/s3/bucket"

  bucket_name = "logs.graduation-thesis.mc123004.sun.ac.jp"
  bucket_acl  = "private"
}
