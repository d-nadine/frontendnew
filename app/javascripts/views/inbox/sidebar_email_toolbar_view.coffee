Radium.SidebarEmailToolbarView = Em.View.extend
  foldersOpen: false
  templateName: 'radium/inbox/sidebar_email_toolbar'
  didInsertElement: ->
    $('.email-action').dropdown()

  toggleFolders: ->
    toggleProperty('foldersOpen')

  foldersOpenDidChange: ( ->
    alert @get('foldersOpen')
  ).observes('foldersOpen')
