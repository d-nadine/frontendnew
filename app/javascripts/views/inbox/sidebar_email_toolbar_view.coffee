Radium.SidebarEmailToolbarView = Em.View.extend
  classNames: 'email-toolbar'
  templateName: 'radium/inbox/sidebar_email_toolbar'
  didInsertElement: ->
    $('.email-action').dropdown()

  mailBinding: 'controller.inboxSidebarController'
  selectedMailBinding: 'controller.inboxController.selectedMail'
