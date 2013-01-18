require 'radium/views/inbox/bulk_email_tasks_form_view'

Radium.BulkEmailActionView = Em.View.extend
  templateName: 'radium/inbox/bulk_email'
  tasksView: Radium.BulkEmailTasksFormView.extend()
