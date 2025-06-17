output "key_pair_id" {
  description = "The ID of the created key pair"
  value       = aws_key_pair.key_pair.id
}