require 'radium/views/emails/email_item_view'
require 'radium/views/emails/email_table_view'

Radium.EmailPanelView = Em.View.extend
  templateName: 'emails/email_panel'
  hasPreviousEmailBinding: 'controller.hasPreviousEmails'

  emailsListView: Em.CollectionView.extend
    itemViewClass: Radium.EmailItemView
    contentBinding: 'controller.limitedContent'

  remainingTableView: Radium.EmailTableView.extend
    contentBinding: 'parentView.controller.remainingContent'
