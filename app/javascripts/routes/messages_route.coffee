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

      email.one 'didUpdate', (result) =>
        Ember.run.next =>
          email.set 'isSending', false
          messagesController = @controllerFor('messages')
          messagesController.get('model').removeObject(result)
          @transitionTo 'emails.sent', email

      email.one 'becameInvalid', =>
        email.set 'isSending', false
        @send 'flashError', email

      email.one 'becameError', =>
        email.set 'isSending', false
        @send 'flashError', 'An error has occurred and the email has not been sent'

      @store.commit()

    toggleFolders: ->
      @toggleProperty 'controller.drawerOpen'
      @send 'toggleDrawer', 'messages/folders'

    selectFolder: (name) ->
      @send 'closeDrawer'

      @transitionTo "messages", name

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

    archive: (item) ->
      return if item.get('isArchived')

      @send 'recalculateModel', item, 'archive'

      foldersIcon = $('.email-folders')

      foldersIcon.addClass('highlight')

      setTimeout ->
        foldersIcon.removeClass('highlight')
      , 3000

    delete: (item) ->
      @send 'recalculateModel', item, 'delete'

    recalculateModel: (item, action) ->
      messagesController = @controllerFor 'messages'

      if messagesController.get('showRoute')
        return @send('removeItem', item, action)

      threadController = @controllerFor('emailsThread')

      replies = threadController.get('sortedReplies')

      if replies.get('length') == 1
        return @send('removeItem', item, action)

      callback = =>
        threadController.get('model').removeObject(item)

        messagesController.get('model').removeObject item

        if item == messagesController.get('selectedContent')
          nextItem = threadController.objectAt(1)
        else
          nextItem = threadController.get('firstObject')

        if action == 'delete'
          @send 'notificationDelete', item

          item.deleteRecord()
          updateEvent = 'didDelete'
        else
          item.set 'archived', true
          updateEvent = 'didUpdate'

        item.one updateEvent, =>
          @transitionTo "emails.thread", messagesController.get("folder"), nextItem

        item.one 'becameInvalid', ->
          sidebarController.set 'isLoading', false

        item.one 'becameError', ->
          sidebarController.set 'isLoading', false

        @get('store').commit()

        return unless item.get('isDirty')

        if action == 'delete'
          @send 'flashSuccess', 'Email deleted'
        else
          @send 'flashSuccess', 'Email archived'

      @send 'animateDelete', item, callback, '.messages-list'

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
          item.set 'archived', true
          updateEvent = 'didUpdate'

        item.one updateEvent, =>
          controller.removeObject item
          sidebarController.set 'isLoading', false
          @send 'selectItem', nextItem
          @controllerFor('messagesSidebar').send('showMore') unless sidebarController.get('allPagesLoaded')

        item.one 'becameInvalid', ->
          sidebarController.set 'isLoading', false

        item.one 'becameError', ->
          sidebarController.set 'isLoading', false

        @get('store').commit()

        return unless item.get('isDirty')

        if action == 'delete'
          @send 'flashSuccess', 'Email deleted'
        else
          @send 'flashSuccess', 'Email archived'

      @send 'animateDelete', item, callback, '.messages-list'

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

    Radium.Email.find(messagesController.requestParams())

  serialize: (model) ->
    folder: @controllerFor('messages').get('folder')

  setupController: (controller, model) ->
    return unless model

    controller.set 'model', model.toArray()

    @controllerFor('messagesSidebar').send 'loadInitialPages'

  renderTemplate: (controller, context) ->
    @render 'messages/drawer_buttons', outlet: 'buttons'

    # FIXME this seems wrong. It uses drawer_panel for
    # some reason. This seems like an Ember bug
    @render into: 'application'

    @render 'messages/sidebar',
      into: 'messages'
      outlet: 'sidebar'

    controller = @controllerFor('messagesSidebar')

    template = if controller.get('searchIsActive') then 'messages/search_form' else 'messages/list'

    @render template,
      into: 'messages/sidebar'
      outlet: 'messages-sidebar-content'
      controller: controller

  deactivate: ->
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

    unless model.get('length')
      folder = messagesController.get('folder') || 'inbox'
      @transitionTo 'emails.empty', folder
      return

    item = model.get('firstObject')

    unless item
      return @transitionTo 'emails.empty', folder

    folder = messagesController.get('folder')

    route = messagesController.get('nextRoute')

    @transitionTo route, folder, item
