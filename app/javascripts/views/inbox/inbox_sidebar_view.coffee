Radium.InboxSidebarView = Em.CollectionView.extend
  contentBinding: 'controller'
  tagName: 'ul'
  classNames: 'messages nav nav-tabs nav-stacked'
  itemViewClass: Radium.SidebarMailItemView
  emptyView: Ember.View.extend
    template: Ember.Handlebars.compile("No mail today!")
