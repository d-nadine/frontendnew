require 'radium/views/inbox/sidebar_mail_item_view'

Radium.InboxSidebarView = Em.CollectionView.extend Radium.SidebarScrollbarMixin,
  contentBinding: 'controller'
  tagName: 'ul'
  classNames: 'messages selectable'
  itemViewClass: Radium.SidebarMailItemView
  emptyView: Ember.View.extend
    templateName: 'radium/inbox/empty_sidebar'
