resource "aws_eip" "this" {
  vpc = true
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.this.id
  subnet_id     = var.subnet_id

  lifecycle {
    ignore_changes = [allocation_id]
  }
}
