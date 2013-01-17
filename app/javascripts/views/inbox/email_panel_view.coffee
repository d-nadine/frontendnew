require 'radium/views/inbox/email_item_view'
require 'radium/views/inbox/email_table_view'

Radium.EmailPanelView = Em.View.extend
  templateName: 'radium/inbox/email_panel'
  hasPreviousEmailBinding: 'controller.hasPreviousEmails'

  emailsListView: Em.CollectionView.extend
    itemViewClass: Radium.EmailItemView
    contentBinding: 'controller.limitedContent'

  remainingTableView: Radium.EmailTableView.extend
    controllerBinding: 'parentView.controller'
