Radium.MessagesRoute = Radium.Route.extend
  actions:
    willTransition: (transition) ->
      currentPath = @controllerFor('application').get('currentPath')
      if ['messages.emails.new', 'messages.bulk_actions'].contains currentPath
        return true

      return true unless transition.targetName == "messages.index"

      sidebarController = @controllerFor('messagesSidebar')

      existingFolder = sidebarController.get('folder')

      if transition.params.messages.folder == existingFolder
        transition.abort()
      else
        sidebarController.send 'reset'
        true

    sendDraft: (email) ->
      email.set 'sentAt', Ember.DateTime.create()
      email.set 'isDraft', false

      email.set 'isSending', true

      email.save().then((result) =>
        Ember.run.next =>
          email.set 'isSending', false
          messagesController = @controllerFor('messages')
          messagesController.get('model').removeObject(result)
          @transitionTo 'emails.sent', email
      ).catch (error) ->
        email.set 'isSending', false

    toggleFolders: ->
      @toggleProperty 'controller.drawerOpen'
      @send 'toggleDrawer', 'messages/folders'

    selectFolder: (folder) ->
      @controllerFor('messages').set('currentFolder', folder)

      @transitionTo "messages", folder.name

      false

    selectItem: (item) ->
      messagesController = @controllerFor('messages')

      folder = messagesController.get('folder')

      unless item
        return @transitionTo 'emails.empty', folder

      folder = messagesController.get('folder')

      route = messagesController.get('nextRoute')

      @transitionTo route, folder, item

    selectSearchScope: (item) ->
      @controllerFor('messages').set 'selectedSearchScope', "Search #{item.title}"

    checkAll: ->
      itemsChecked = @controllerFor('messages').get('hasCheckedContent')
      @controllerFor('messages').setEach 'isChecked', !itemsChecked

      @controllerFor('messagesSidebar').send 'checkMessageItem'

    archive: (item, fromSidebar) ->
      return if item.get('isArchived')

      item.set 'archived', true

      @recalculateModel(item, 'archive', fromSidebar)

      foldersIcon = $('.email-folders')

      foldersIcon.addClass('highlight')

      setTimeout ->
        foldersIcon.removeClass('highlight')
      , 3000

    delete: (item, fromSidebar) ->
      @recalculateModel(item, 'delete', fromSidebar)

  removeItem: (item, action) ->
    callback = =>
      controller = @controllerFor('messages')
      sidebarController = @controllerFor('messagesSidebar')

      sidebarController.set 'isLoading', true

      if item == controller.get('selectedContent')
        nextItem = controller.get('nextItem')
      else
        nextItem = controller.get('selectedContent')

      if action == 'delete'
        @send 'notificationDelete', item

        item.deleteRecord()
        updateEvent = 'didDelete'
      else
        item.set 'folder', 'archive'
        updateEvent = 'didUpdate'

      item.one updateEvent, =>
        controller.removeObject item
        sidebarController.set 'isLoading', false

        if controller.get('currentPath') == "messages.templates.edit" && !controller.get('length')
          return @transitionTo "templates.new"

        @send 'selectItem', nextItem
        @controllerFor('messagesSidebar').send('showMore') unless sidebarController.get('allPagesLoaded')

      item.one 'becameInvalid', ->
        item.set 'isTransitioning', false
        sidebarController.set 'isLoading', false

      item.one 'becameError', ->
        item.set 'isTransitioning', false
        sidebarController.set 'isLoading', false

      @get('store').commit()

      return unless item.get('isDirty')

      if action == 'delete'
        @send 'flashSuccess', 'Email deleted'
      else
        @send 'flashSuccess', 'Email archived'

    @send 'animateDelete', item, callback, '.messages-list'

  recalculateModel: (item, action, fromSidebar) ->
    messagesController = @controllerFor 'messages'
    sidebarController = @controllerFor 'messagesSidebar'

    if messagesController.get('unthreadedRoute')
      return @removeItem(item, action)

    threadController = @controllerFor('emailsThread')

    isFirstInThread = threadController.get('firstObject') == item

    if isFirstInThread
      replies = threadController.get('model')

      if replies.get('length') == 1
        return @removeItem(item, action)

    isSelectedContent = (item == messagesController.get('selectedContent'))

    callback = =>
      messagesController.removeObject(item)
      threadController.removeObject(item)

      if action == 'delete'
        @send 'notificationDelete', item

        item.deleteRecord()
        updateEvent = 'didDelete'
      else
        updateEvent = 'didUpdate'

      item.one updateEvent, =>
        if isSelectedContent
          currentUser = @controllerFor('currentUser').get('model')

          nextItem = threadController.find (email) -> email.get('sender') != currentUser

          return unless nextItem

          messagesController.get('model').insertAt(0, nextItem)
          @transitionTo "emails.thread", messagesController.get("folder"), nextItem
          return

        return unless fromSidebar

        sidebarController = @controllerFor('messagesSidebar')

        sidebarController.send 'reset'

        sidebarController.get('container').lookup('route:messages').refresh()

      item.one 'becameInvalid', ->
        item.set 'isTransitioning', false
        sidebarController.set 'isLoading', false

      item.one 'becameError', ->
        item.set 'isTransitioning', false
        sidebarController.set 'isLoading', false

      @get('store').commit()

      return unless item.get('isDirty')

      if action == 'delete'
        @send 'flashSuccess', 'Email deleted'
      else
        @send 'flashSuccess', 'Email archived'

    if isSelectedContent || fromSidebar
      @send 'animateDelete', item, callback, '.messages-list'
    else
      callback()

  transitionToBulkOrBack: ->
    currentPath = @controllerFor('application').get('currentPath')
    onBulkActions = currentPath is 'messages.bulk_actions'

    itemsChecked = @controllerFor('messages').get('hasCheckedContent')

    if !onBulkActions && itemsChecked
      @transitionTo 'messages.bulk_actions'
    else if !itemsChecked
      @send 'back'

  model: (params, transition) ->
    messagesController = @controllerFor('messages')
    sidebarController = @controllerFor('messagesSidebar')

    messagesController.set('folder', params.folder)

    return if sidebarController.get('searchIsActive')

    requestType = messagesController.requestType()

    requestType.find(messagesController.requestParams())

  serialize: (model) ->
    folder: @controllerFor('messages').get('folder')

  setupController: (controller, model) ->
    return unless model

    controller.set 'model', model.toArray()

    return unless model.get('length')

    @controllerFor('messagesSidebar').send 'loadInitialPages'

  renderTemplate: (controller, context) ->
    @render 'messages/drawer_buttons', outlet: 'buttons'

    # FIXME this seems wrong. It uses drawer_panel for
    # some reason. This seems like an Ember bug
    @render into: 'application'

    @render 'messages/sidebar',
      into: 'messages'
      outlet: 'sidebar'

    @render 'messages/topnav',
      into: 'messages'
      outlet: 'topnav'

    controller = @controllerFor('messagesSidebar')

    template = if controller.get('searchIsActive') then 'messages/search_form' else 'messages/list'

    @render template,
      into: 'messages/sidebar'
      outlet: 'messages-sidebar-content'
      controller: controller

  activate: ->
    @_super.apply this, arguments

    return if @controllerFor('currentUser').get('initialMailImported')

    initImportPoller = @get('initialImportPoller')

    return if initImportPoller.get('isPolling')

    initImportPoller.start()

  deactivate: ->
    @_super.apply this, arguments
    initImportPoller = @get('initialImportPoller')

    if initImportPoller.get('isPolling')
      initImportPoller.stop()

    @controllerFor('messagesSidebar').send 'reset'
    @render 'nothing',
      into: 'application'
      outlet: 'buttons'
    @send 'closeDrawer'

Radium.MessagesIndexRoute = Radium.Route.extend
  beforeModel: ->
    @controllerFor('messagesSidebar').send 'reset'

  afterModel: (model, transition) ->
    return if @controllerFor('messagesSidebar').get('searchIsActive')

    return unless transition.targetName == "messages.index"

    messagesController = @controllerFor 'messages'

    transitionToEmpty = =>
      folder = messagesController.get('folder') || 'inbox'

      @transitionTo 'emails.empty', folder

      return

    unless model.get('length')
      return transitionToEmpty()

    item = model.get('firstObject')

    unless item
      return transitionToEmpty()

    folder = messagesController.get('folder')

    route = messagesController.get('nextRoute')

    @transitionTo route, folder, item
