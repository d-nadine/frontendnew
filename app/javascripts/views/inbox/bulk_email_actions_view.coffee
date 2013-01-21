require 'radium/views/forms/bulk_action_form_widget'
require 'radium/views/inbox/email_table_view'

Radium.BulkEmailActionsView = Em.View.extend
  templateName: 'radium/inbox/bulk_email'
  FormWidget: Radium.BulkActionFormWidget.extend()
  checkedEmailTableView: Radium.EmailTableView.extend
    contentBinding: 'parentView.controller'
