require 'radium/views/emails/email_item_view'

Radium.EmailsEmailPanelView = Em.View.extend
  templateName: 'emails/email_panel'
  hasPreviousEmailBinding: 'controller.hasPreviousEmails'

  emailsListView: Em.CollectionView.extend
    itemViewClass: Radium.EmailItemView
    contentBinding: 'controller.limitedContent'
