output "environment" {
  description = "Selected environment"
  value       = var.environment
}

output "name_prefix" {
  description = "Generated project prefix"
  value       = local.name_prefix
}

output "uppercase_names" {
  description = "Names converted to uppercase"
  value       = local.uppercase_names
}

output "common_tags" {
  description = "Merged project tags"
  value       = local.common_tags
}
