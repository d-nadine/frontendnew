Radium.EmailsSentRoute = Ember.Route.extend
  events:
    addTask: (email) ->
      email.set 'showFormBox', true
      @transitionTo 'emails.show', email
