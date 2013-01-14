Radium.SidebarEmailToolbarController = Em.ArrayController.extend
  foldersOpen: true

  toggleFolders: ->
    @toggleProperty('foldersOpen')

  foldersOpenDidChange: ( ->
    foldersOpen = @get('foldersOpen')

    actionName = if foldersOpen then 'showInbox' else 'showMessagesMenu'

    Radium.get('router').send(actionName)
  ).observes('foldersOpen')
