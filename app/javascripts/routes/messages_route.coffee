Radium.MessagesRoute = Radium.Route.extend
  actions:
    willTransition: (transition) ->
      currentPath = @controllerFor('application').get('currentPath')
      if ['messages.emails.new', 'messages.bulk_actions'].contains currentPath
        return true

      return true unless transition.targetName == "messages.index"

      sidebarController = @controllerFor('messagesSidebar')

      existingFolder = sidebarController.get('folder')

      if transition.params.folder == existingFolder
        transition.abort()
      else
        sidebarController.send 'reset'
        true

    toggleFolders: ->
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

      @transitionToBulkOrBack()

    delete: (item) ->
      @animateDelete item, =>
        controller = @controllerFor('messages')

        if item == controller.get('selectedContent')
          nextItem = controller.get('nextItem')
        else
          nextItem = controller.get('selectedContent')

        @send 'notificationDelete', item

        @controllerFor('messagesSidebar').send('showMore')

        item.deleteRecord()
        @get('store').commit()

        return unless item.get('isDirty')

        @send 'flashSuccess', 'Email deleted'

        Ember.run.next =>
          @send 'selectItem', nextItem

  # TODO: figure out a better way to do this
  animateDelete: (item, callback) ->
    duration = 600

    modelSelector = "[data-model='#{item.constructor}'][data-id='#{item.get('id')}']"
    $(".messages-list #{modelSelector}").fadeOut duration
    # $(".email-card.message-card").animate {left: "-120%", height: 0}, duration, ->
    #   $(this).hide()

    Ember.run.later this, callback, duration

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

    model = @modelFor 'messages'

    model?.destroy()

    return if sidebarController.get('searchIsActive')

    queryParams = Ember.merge(messagesController.queryParams(), page_size: 1)

    Radium.Email.find(queryParams)

  serialize: (model) ->
    folder: @controllerFor('messages').get('folder')

  afterModel: (model, transitioin) ->
    sidebarController = @controllerFor('messagesSidebar')

    return if sidebarController.get('searchIsActive')
    return if sidebarController.get('page') > 0 && @controllerFor('currentUser').get('initialMailImported')

    meta = @get('store').typeMapFor(Radium.Email).metadata

    Ember.run.next =>
      sidebarController.set('totalRecords', meta.totalRecords)
      sidebarController.set('allPagesLoaded', meta.allPagesLoaded)

    if meta.totalRecords > 0
      for i in [0...3]
        sidebarController.send 'showMore'

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

    Ember.run.next =>
      Ember.$('.scroller').tinyscrollbar_update('relative')

  deactivate: ->
    @controllerFor('messagesSidebar').send 'reset'
    @render 'nothing',
      into: 'application'
      outlet: 'buttons'
    @send 'closeDrawer'
