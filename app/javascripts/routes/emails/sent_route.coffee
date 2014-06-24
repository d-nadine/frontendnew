Radium.EmailsSentRoute = Ember.Route.extend
  actions:
    addTask: (email) ->
      email.set 'showFormBox', true
      @transitionTo 'emails.show', email

  activate: ->
    @controllerFor('messagesSidebar').send 'reset'

