Radium.MessagesRoute = Radium.Route.extend
  events:
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

          item.deleteRecord()
          @get('store').commit()

          @send 'selectItem', controller.get('nextItem')
        else
          item.deleteRecord()
          @get('store').commit()

  # TODO: figure out a better way to do this
  animateDelete: (item, callback) ->
    duration = 600

    modelSelector = "[data-model='#{item.constructor}'][data-id='#{item.get('id')}']"
    $("#main-panel #{modelSelector}").fadeOut duration
    $("#sidebar #{modelSelector}").animate {left: "-120%", height: 0}, duration, ->
      $(this).hide()

    Ember.run.later this, callback, duration

  transitionToBulkOrBack: ->
    currentPath = @controllerFor('application').get('currentPath')
    onBulkActions = currentPath is 'messages.bulk_actions'

    itemsChecked = @controllerFor('messages').get('hasCheckedContent')

    if !onBulkActions && itemsChecked
      @transitionTo 'messages.bulk_actions'
    else if !itemsChecked
      @send 'back'

  renderTemplate: (controller, context) ->
    @render 'messages/drawer_buttons', outlet: 'buttons'

    # FIXME this seems wrong. It uses drawer_panel for
    # some reason. This seems like an Ember bug
    @render into: 'application'

    @render 'messages/sidebar',
      into: 'messages'
      outlet: 'sidebar'

  deactivate: ->
    @controllerFor('messagesSidebar').reset()
    @render 'nothing',
      into: 'application'
      outlet: 'buttons'

    @send 'closeDrawer'

Radium.MessagesIndexRoute = Radium.Route.extend
  beforeModel: ->
    messagesController = @controllerFor('messages')
    messages = messagesController.get('model.content')
    if ((!messages) || (!messages.get('length')))
      folder = messagesController.get('folder') || 'inbox'
      @transitionTo 'emails.empty', folder
      return

    messages = messages.sort (a, b) =>
      Ember.DateTime.compare(a.get('time'), b.get('time'))
    item = messages.get('lastObject')

    if item instanceof Radium.Email
      @transitionTo 'emails.show', item
    else if item instanceof Radium.Discussion
      @transitionTo 'messages.discussion', item
