resource "aws_subnet" "this" {
  vpc_id            = var.vpc_id
  cidr_block        = element(var.cidr_blocks, count.index)
  availability_zone = element(var.availability_zones, count.index)
  count             = length(var.cidr_blocks)

  tags = {
    Name = "${var.name}_${element(var.availability_zones, count.index)}"
  }
}
