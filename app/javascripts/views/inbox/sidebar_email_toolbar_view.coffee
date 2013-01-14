Radium.SidebarEmailToolbarView = Em.View.extend
  templateName: 'radium/inbox/sidebar_email_toolbar'
  didInsertElement: ->
    $('.email-action').dropdown()
