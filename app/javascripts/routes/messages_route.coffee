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

    check: (item) ->
      item.toggleProperty 'isChecked'

      @transitionToBulkOrBack()

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

  model: ->
     messages = Radium.MessageArrayProxy.create
      currentUser: @controllerFor('currentUser').get('model')

     messages.load()

     messages

  renderTemplate: (controller, context) ->
    @render 'messages/drawer_buttons', outlet: 'buttons'

    # FIXME this seems wrong. It uses drawer_panel for
    # some reason. This seems like an Ember bug
    @render into: 'application'

    @render 'messages/sidebar',
      into: 'messages'
      outlet: 'sidebar'

  deactivate: ->
    @render 'nothing', 
      into: 'application'
      outlet: 'buttons'

    @send 'closeDrawer'

Radium.MessagesIndexRoute = Radium.Route.extend
  beforeModel: ->
    messages = @modelFor('messages')
    item = messages.get('firstObject')
    return unless item

    if item instanceof Radium.Email
      @transitionTo 'emails.show', item
    else if item instanceof Radium.Discussion
      @transitionTo 'messages.discussion', item
