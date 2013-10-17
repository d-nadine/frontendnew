Radium.MessagesRoute = Radium.Route.extend
  actions:
    willTransition: (transition) ->
      transition.abort() if transition.targetName == "messages.index"

      true

    toggleFolders: ->
      @send 'toggleDrawer', 'messages/folders'

    selectFolder: (name) ->
      @controllerFor('messages').set 'folder', name
      @send 'closeDrawer'

      Ember.run.next =>
        @send 'selectItem', @controllerFor('messages').get('firstObject')

    selectItem: (item) ->
      if item instanceof Radium.Email
        @transitionTo 'emails.show', item
      else if item instanceof Radium.Discussion
        @transitionTo 'messages.discussion', item
      else
        folder = @controllerFor('messages').get('model.folder')
        @transitionTo 'emails.empty', folder

    check: (item) ->
      item.toggleProperty 'isChecked'

      @transitionToBulkOrBack()

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

        @controllerFor('messagesSidebar').send('showMore')

        item.deleteRecord()
        @get('store').commit()

        Ember.run.next =>
          @send 'selectItem', nextItem

    selectTab: (tab) ->
      controller = @controllerFor('messagesSidebar')

      controller.set 'activeTab', tab

      if tab != 'search'
        controller.set('controllers.messages.folder', tab)

      template = if tab == 'search'
                   'messages/search_form'
                 else
                    'messages/list'

      @render template,
        into: 'messages/sidebar'
        outlet: 'messages-sidebar-content'
        controller: controller

      Ember.run.next =>
        @send 'selectItem', @controllerFor('messages').get('firstObject')

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
    @controllerFor('messages').set('folder', params.folder)

    model = @modelFor 'messages'

    model.destroy() if model

    folder = @controllerFor('messagesSidebar').get('queryFolder')

    Radium.Email.find(user_id: @get('currentUser.id'), folder: folder,  page: 1, page_size: 1)

  serialize: (model) ->
    folder: @controllerFor('messages').get('folder')

  afterModel: (model, transitioin) ->
    sidebarController = @controllerFor('messagesSidebar')

    return if sidebarController.get('page') > 0

    meta = @get('store').typeMapFor(Radium.Email).metadata

    Ember.run.next =>
      sidebarController.set('totalRecords', meta.totalRecords)
      sidebarController.set('allPagesLoaded', meta.allPagesLoaded)

    sidebarController.send 'showMore'

    sidebarController.send 'showMore' if sidebarController.get('totalRecords') > 10

    return unless transitioin.targetName == "messages.index"

    unless model.get('length')
      folder = model.get('folder') || 'inbox'
      @transitionTo 'emails.empty', folder
      return

    item = model.get('firstObject')

    if item instanceof Radium.Email
      @transitionTo 'emails.show', item
    else if item instanceof Radium.Discussion
      @transitionTo 'messages.discussion', item

  setupController: (controller, model) ->
    controller.set 'model', model.toArray()

  renderTemplate: (controller, context) ->
    @render 'messages/drawer_buttons', outlet: 'buttons'

    # FIXME this seems wrong. It uses drawer_panel for
    # some reason. This seems like an Ember bug
    @render into: 'application'

    @render 'messages/sidebar',
      into: 'messages'
      outlet: 'sidebar'

    @render 'messages/list',
      into: 'messages/sidebar'
      outlet: 'messages-sidebar-content'
      controller: @controllerFor('messagesSidebar')

    Ember.run.next =>
      Ember.$('.scroller').tinyscrollbar_update('relative')

  deactivate: ->
    @controllerFor('messagesSidebar').send 'reset'
    @render 'nothing',
      into: 'application'
      outlet: 'buttons'
    @send 'closeDrawer'
