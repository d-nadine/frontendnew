require 'mixins/controllers/save_email_mixin'
require 'routes/mixins/send_email_mixin'

Radium.EmailsNewRoute = Ember.Route.extend  Radium.SaveEmailMixin, Radium.SendEmailMixin,
  actions:
    willTransition: (transition) ->
      if transition.targetName == "messages.index"
        controller = @controllerFor('messages')
        @controllerFor('messagesSidebar').send 'reset'

        @transitionTo 'messages.index', transition.params.folder

        return false

      true

    deleteFromEditor: ->
      @controllerFor('messagesSidebar').send 'reset'
      Ember.run.next =>
        @transitionTo 'messages', @controllerFor('messages').get('folder')

  deactivate: ->
    @controllerFor('emailsNew').get('newEmail').reset()
    @controllerFor('messagesSidebar').send 'reset'
