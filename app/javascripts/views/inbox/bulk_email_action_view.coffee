require 'radium/views/forms/bulk_action_form_widget'

Radium.BulkEmailActionView = Em.View.extend
  templateName: 'radium/inbox/bulk_email'
  FormWidget: Radium.BulkActionFormWidget.extend()
  kind: 'email'
