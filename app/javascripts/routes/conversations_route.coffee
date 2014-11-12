require 'mixins/controllers/track_contact_mixin'

Radium.ConversationsRoute = Radium.Route.extend Radium.TrackContactMixin,
  actions:
    delete: (email) ->
      @send 'removeItem', 'delete', email
      false

    archive: (email) ->
      @send 'removeItem', 'archive', email
      false

    ignore: (email, contact) ->
      @send 'removeItem', 'ignore', email, contact
      false

    removeItem: (action, email, contact) ->
      controller = @controllerFor 'conversations'

      callback = =>
        finish = =>
          @send 'flashSuccess', "email #{action}d!"
          if action == 'archive'
            @refresh()
          else
            @controllerFor('conversations').removeObject email

        if action == 'delete'
          @send 'notificationDelete', email

          email.deleteRecord()
          updateEvent = 'didDelete'
        else if action == 'archive'
          email.set 'archived', true
          updateEvent = 'didUpdate'
        else if action == 'ignore'
          ignore = @controllerFor('conversations').get('isIgnored')
          contact.set 'ignored', not ignore
          contact.one 'didUpdate', finish
          return @get('store').commit()

        email.one updateEvent, finish

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

    controller.send 'reset'

    controller.set 'isLoading', true
    controller.set 'totalsLoading', true
    controller.set('conversationType', type)
    type

  model: (params) ->
    Radium.Email.find(name: params.type, pageSize: 15)

  setupController: (controller, model) ->
    @_super.apply this, arguments
    controller.set 'model', model.toArray()
    controller.set 'isLoading', false
    controller.send 'updateTotals'

    return if controller.get 'allPagesLoaded'

    for i in [0...2]
      controller.send 'showMore'

  deactivate: ->
    @_super.apply this, arguments
    controller = @controllerFor 'conversations'
    return unless controller.get('hasCheckedContent')

    controller.get('checkedContent').forEach (email) ->
      email.set 'isChecked', false