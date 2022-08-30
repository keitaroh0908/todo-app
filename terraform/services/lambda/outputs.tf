output "get_task_invoke_arn" {
  value = module.get_task.invoke_arn
}

output "get_tasks_by_user_id_invoke_arn" {
  value = module.get_tasks_by_user_id.invoke_arn
}

output "create_task_invoke_arn" {
  value = module.create_task.invoke_arn
}

output "update_task_invoke_arn" {
  value = module.update_task.invoke_arn
}
