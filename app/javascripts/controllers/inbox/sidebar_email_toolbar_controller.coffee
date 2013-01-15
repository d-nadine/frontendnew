Radium.SidebarEmailToolbarController = Em.ArrayController.extend
  foldersOpen: false
  folderLabel: 'inbox'
  folder: null
  selectedMailMailBinding: 'inboxController.selectedMail'

  markSelected: ->
    unselected = @get('inboxSidebarController').filter (email) -> !email.get('isSelected')

    unselected.forEach (email) -> email.set('isSelected', true)
  markUnSelected: ->
    unselected = @get('inboxSidebarController').filter (email) -> email.get('isSelected')

    unselected.forEach (email) -> email.set('isSelected', false)

  markRead:->
    @markEmailRead(true)

  markUnread:->
    @markEmailRead(false)

  markEmailRead: (isRead) ->
    selected = @get('inboxController.selectedMail')
    return if selected.get('length') == 0

    selected.forEach (email) ->
      email.set('read', isRead) unless email.get('read') == isRead

    @get('store').commit()

  toggleFolders: () ->
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

    @toggleFolders()
