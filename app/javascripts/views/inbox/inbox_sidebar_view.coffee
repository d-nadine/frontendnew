Radium.InboxSidebarView = Em.CollectionView.extend
  contentBinding: 'controller'
  tagName: 'ul'
  classNames: 'messages nav nav-tabs nav-stacked'
  itemViewClass: Radium.SidebarMailItemView
  emptyView: Ember.View.extend
    templateName: 'radium/inbox/empty_sidebar'
  didInsertElement: ->
    $('#sidebar').tinyscrollbar()
