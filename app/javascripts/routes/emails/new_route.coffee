Radium.EmailsNewRoute = Ember.Route.extend
  events: 
    submit: (form) ->
      form.set 'isSubmitted', true
      return unless form.get('isValid')

      @render 'emails/sending',
        into: 'emails'
        outlet: 'modal'

      email = Radium.Email.createRecord form.get('data')

      email.on 'didCreate', =>
        Ember.run.later(this, (->
          @transitionTo 'emails.sent', email
        ), 1200)

      @store.commit()
