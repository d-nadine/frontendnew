Radium.SidebarEmailToolbarView = Em.View.extend
  classNames: 'email-toolbar'
  templateName: 'radium/inbox/sidebar_email_toolbar'

  folderBinding: Ember.Binding.oneWay 'controller.folder'
  totalBinding: Ember.Binding.oneWay 'controller.length'

  didInsertElement: ->
    @$('.dropdown-toggle').dropdown()
