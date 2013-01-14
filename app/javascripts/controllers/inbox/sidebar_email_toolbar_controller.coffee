Radium.SidebarEmailToolbarController = Em.ArrayController.extend
  foldersOpen: false
  folderLabel: 'inbox'
  folder: null

  toggleFolders: (folder) ->
    foldersOpen = @get('foldersOpen')

    unless @get('foldersOpen')
      @set('foldersOpen', true)
      Radium.get('router').send('showMessagesMenu')
      return

    folder = @get('folder')

    folderName = if folder  then folder.get('name') else 'inbox'

    @set('foldersOpen', false)

    Radium.get('router').send('showMessage', folderName)

  setFolder: (folder) ->
    @set('foldersOpen', true)
    @set('folder', folder)
    @set('folderLabel', folder.label)

    @toggleFolders(folder)
