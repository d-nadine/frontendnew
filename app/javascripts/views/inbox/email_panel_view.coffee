require 'radium/views/inbox/email_item_view'

Radium.EmailPanelView = Em.View.extend
  templateName: 'radium/inbox/email_panel'
  hasPreviousEmailBinding: 'controller.hasPreviousEmails'

  EmailsListView: Em.CollectionView.extend
    itemViewClass: Radium.EmailItemView
    contentBinding: 'controller.limitedContent'
