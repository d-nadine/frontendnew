require 'radium/views/inbox/email_item_view'

Radium.EmailView = Em.CollectionView.extend
  itemViewClass: Radium.EmailItemView
  contentBinding: 'controller.limitedContent'
