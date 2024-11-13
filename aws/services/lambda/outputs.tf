output "get_tasks_by_user_id_invoke_arn" {
  value = module.get_tasks_by_user_id.invoke_arn
}

output "create_task_invoke_arn" {
  value = module.create_task.invoke_arn
}

output "delete_task_invoke_arn" {
  value = module.delete_task.invoke_arn
}
