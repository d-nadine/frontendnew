require 'mixins/controllers/track_contact_mixin'

Radium.ConversationsRoute = Radium.Route.extend Radium.TrackContactMixin,
  actions:
    delete: (email) ->
      @send 'removeItem', 'delete', email
      false

    archive: (email) ->
      @send 'removeItem', 'archive', email
      false

    ignore: (email) ->
      @send 'removeItem', 'ignore', email
      false

    # FIXME: we should not have to handle this in the route
    # but as it is in a users loop, the call gets routed here
    # from conversations.hbs
    assignAll: (user) ->
      @controllerFor('conversations').send 'assignAll', user
      false

    removeItem: (action, email) ->
      controller = @controllerFor 'conversations'

      callback = =>
        if action == 'delete'
          @send 'notificationDelete', email

          email.deleteRecord()
          updateEvent = 'didDelete'
        else
          email.set 'archived', true
          updateEvent = 'didUpdate'

        email.one updateEvent, =>
          @send 'flashSuccess', "email #{action}d!"
          @refresh()

        errorMessage = "an error has occurred and the email could not be #{action}d"

        email.one 'becameInvalid', ->
          @send 'flashError', errorMessage

        email.one 'becameError', ->
          @send 'flashError', errorMessage

        @get('store').commit()

      modelSelector = "[data-model='#{email.constructor}'][data-id='#{email.get('id')}']"
      $("#{modelSelector}".trim()).fadeOut 'medium', callback

  beforeModel: (transition) ->
    type = transition.params.conversations.type
    controller = @controllerFor 'conversations'
    controller.set 'isLoading', true
    controller.set 'totalsLoading', true
    controller.set('conversationType', type)
    type

  model: (params) ->
    Radium.Email.find(name: params.type)

  setupController: (controller, model) ->
    @_super.apply this, arguments
    controller.set 'model', model
    controller.set 'isLoading', false
    controller.send 'updateTotals'

  deactivate: ->
    @_super.apply this, arguments
    controller = @controllerFor 'conversations'
    return unless controller.get('hasCheckedContent')

    controller.get('checkedContent').forEach (email) ->
      email.set 'isChecked', false