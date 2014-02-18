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
      if item instanceof Radium.Email
        @transitionTo 'emails.show', item
      else if item instanceof Radium.Discussion
        @transitionTo 'messages.discussion', item
      else
        folder = @controllerFor('messages').get('model.folder')
        @transitionTo 'emails.empty', folder

    selectSearchScope: (item) ->
      @controllerFor('messages').set 'selectedSearchScope', "Search #{item.title}"

    checkAll: ->
      itemsChecked = @controllerFor('messages').get('hasCheckedContent')
      @controllerFor('messages').setEach 'isChecked', !itemsChecked

      @controllerFor('messagesSidebar').send 'checkMessageItem'

    delete: (item) ->
      callback = =>
        controller = @controllerFor('messages')
        sidebarController = @controllerFor('messagesSidebar')

        sidebarController.set 'isLoading', true

        if item == controller.get('selectedContent')
          nextItem = controller.get('nextItem')
        else
          nextItem = controller.get('selectedContent')

        @send 'notificationDelete', item

        item.deleteRecord()

        item.one 'didDelete', =>
          controller.removeObject item
          sidebarController.set 'isLoading', false
          @send 'selectItem', nextItem
          @controllerFor('messagesSidebar').send('showMore') unless sidebarController.get('allPagesLoaded')

        item.one 'becameInvalid', =>
          sidebarController.set 'isLoading', false

        item.one 'becameError', =>
          sidebarController.set 'isLoading', false

        @get('store').commit()

        return unless item.get('isDirty')

        @send 'flashSuccess', 'Email deleted'

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
    @set('time', new Date())
    messagesController = @controllerFor('messages')
    sidebarController = @controllerFor('messagesSidebar')

    messagesController.set('folder', params.folder)

    model = @modelFor 'messages'

    model?.destroy()

    return if sidebarController.get('searchIsActive')

    Radium.Email.find(messagesController.queryParams())

  serialize: (model) ->
    folder: @controllerFor('messages').get('folder')

  afterModel: (model, transitioin) ->
    now = new Date()

    diff = Math.ceil(now.getTime() - @get('time').getTime()) / 100

    console.log "model hook took #{diff} seconds"

    sidebarController = @controllerFor('messagesSidebar')

    return if sidebarController.get('searchIsActive')
    return if sidebarController.get('page') > 1 && @controllerFor('currentUser').get('initialMailImported')

    meta = @get('store').typeMapFor(Radium.Email).metadata

    Ember.run.next =>
      sidebarController.set('totalRecords', meta.totalRecords)
      sidebarController.set('allPagesLoaded', meta.allPagesLoaded)

    pageSize = @controllerFor('messages').get('pageSize')

    if meta.totalRecords > pageSize
      for i in [0...3]
        currentCount = (i + 1) * pageSize
        sidebarController.send 'showMore' if meta.totalRecords >= currentCount

    return unless transitioin.targetName == "messages.index"

    unless model.get('length')
      folder = model.get('folder') || 'inbox'
      @transitionTo 'emails.empty'
      return

    item = model.get('firstObject')

    if item instanceof Radium.Email
      @transitionTo 'emails.show', item
    else if item instanceof Radium.Discussion
      @transitionTo 'messages.discussion', item

  setupController: (controller, model) ->
    return unless model

    controller.set 'model', model.toArray()

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
