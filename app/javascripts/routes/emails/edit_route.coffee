Radium.EmailsEditRoute = Radium.Route.extend
  afterModel: (model, transition) ->
    emailForm = Radium.NewEmailForm.create()
    emailForm.reset()

    emailForm.setProperties 
      subject: email.get('subject')
      message: email.get('message')
      to: @get('to').toArray()
