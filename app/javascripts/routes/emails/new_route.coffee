require 'routes/mixins/send_email_mixin'

Radium.EmailsNewRoute = Ember.Route.extend Radium.SendEmailMixin,
  actions:
    willTransition: (transition) ->
      if transition.targetName == "messages.index"
        controller = @controllerFor('messages')
        @controllerFor('messagesSidebar').send 'reset'

        if controller.get('model.length')
          @transitionTo 'emails.show', "inbox", controller.get('firstObject')
        else
          @transitionTo 'emails.empty', "inbox"

        return false

      true

    cancelCreate: ->
      @controllerFor('messagesSidebar').send 'reset'
      Ember.run.next =>
        @transitionTo 'messages', @controllerFor('messages').get('folder')

  deactivate: ->
    @controllerFor('emailsNew').get('newEmail').reset()
    @controllerFor('messagesSidebar').send 'reset'
