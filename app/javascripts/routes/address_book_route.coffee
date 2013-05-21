Radium.AddressbookRoute = Radium.Route.extend
  events:
    sendEmail: (form) ->
      form.set 'isSubmitted', true
      return unless form.get('isValid')

      email = Radium.Email.createRecord form.get('data')

      email.set 'sender', @controllerFor('currentUser').get('model')

      @controllerFor('addressbook').set 'activeForm', null

      @controllerFor('emailsSent').set('model', form)

      @render 'emails/sent',
        into: 'addressbook'
        outlet: 'confirmation'

    closeEmailConfirmation: ->
      @render 'nothing',
        into: 'addressbook'
        outlet: 'confirmation'

  model: ->
    addressBookProxy = Radium.AddressBookArrayProxy.create
      currentUser: @controllerFor('currentUser').get('model')

    addressBookProxy.load()

    addressBookProxy
