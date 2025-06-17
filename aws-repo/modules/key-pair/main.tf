resource "aws_key_pair" "key_pair" {
  key_name   = "${var.key_pair_name}-thalt"
  public_key = var.public_key
}