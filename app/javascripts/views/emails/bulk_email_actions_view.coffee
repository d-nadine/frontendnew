require 'radium/views/forms/bulk_action_form_widget'
require 'radium/views/emails/email_table_view'

Radium.BulkEmailActionsView = Em.View.extend
  templateName: 'emails/bulk_email_actions'
  FormWidget: Radium.BulkActionFormWidget.extend()
  checkedEmailTableView: Radium.EmailTableView.extend
    contentBinding: 'parentView.controller'
