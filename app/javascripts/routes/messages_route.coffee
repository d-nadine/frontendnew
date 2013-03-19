require 'routes/drawer_support_mixin'

Radium.MessagesRoute = Ember.Route.extend Radium.DrawerSupportMixin,
  events:
    selectFolder: (name) ->
      @controllerFor('messages').set 'selectedContent', null
      @controllerFor('messages').set 'folder', name
      @closeDrawer()

    toggleFolders: ->
      @toggleDrawer 'messages/folders'

    selectItem: (item) ->
      if item instanceof Radium.Email
        @transitionTo 'messages.email', item
      else if item instanceof Radium.Discussion
        @transitionTo 'messages.discussion', item

    check: (item) ->
      item.toggleProperty 'isChecked'

      @transitionToBulkOrBack()

    checkAll: ->
      itemsChecked = @controllerFor('messages').get('hasCheckedContent')
      @controllerFor('messages').setEach 'isChecked', !itemsChecked

      @transitionToBulkOrBack()

  transitionToBulkOrBack: ->
    currentPath = @controllerFor('application').get('currentPath')
    onBulkActions = currentPath is 'messages.bulk_actions'

    itemsChecked = @controllerFor('messages').get('hasCheckedContent')

    if !onBulkActions && itemsChecked
      @transitionTo 'messages.bulk_actions'
    else if !itemsChecked
      @send 'back'

  model: ->
    Radium.Message.create folder: 'inbox'

  renderTemplate: ->
    # FIXME this seems wrong. It uses drawer_panel for
    # some reason. This seems like an Ember bug
    @render into: 'application'

    @render 'messages/sidebar',
      into: 'messages'
      outlet: 'sidebar'

    @render 'messages/drawer_buttons',
      into: 'drawer_panel'
      outlet: 'buttons'
