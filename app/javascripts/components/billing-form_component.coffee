require 'lib/radium/value_validation_mixin'

Radium.BillingFormComponent = Ember.Component.extend
  actions:
    createTokenAndSubmit: ->
      accountController = @get('accountController')

      accountController.set 'isPersisting', true

      accountController.set('isSubmitted', true)

      accountController.applyBufferedChanges()

      unless accountController.get('isValid')
        accountController.set 'isPersisting', false
        return

      stripeResponseHandler = (status, response) ->
        unless response.error
          unless @get('updatingExistingCreditCard')
            Ember.$.scrollTo('.upgrade-plan', 800, {offset: - 100})
            accountController.set 'token', response.id
            accountController.send 'update'
          else
            @send 'updateCreditCard', response.id
        else
          @$('#card-number').focus()
          accountController.set 'isPersisting', false
          accountController.send 'flashError', response.error.message

      # test credit card number #4242424242424242
      # raise errors https://stripe.com/docs/testing
      # card declined 4000000000000002
      Stripe.card.createToken
        number: $('#card-number').val(),
        cvc: $('#card-cvc').val(),
        exp_month: $('#card-expiry-month').val(),
        exp_year: $('#card-expiry-year').val()
      , stripeResponseHandler.bind(this)
      false

    updateCreditCard: (token) ->
      updateCC = Radium.UpdateBilling.createRecord
                 token: token

      updateCC.save().then( =>
        @get('flashMessenger').success "Your credit card has been updated, reloading in 5 seconds"
        setInterval((-> window.location.reload()), 3000)
      )
    scrollToCard: ->
      Ember.$.scrollTo('.settings-group', 800, {offset: - 100})
      false

    cancelUpdatingCreditCard: ->
      @set "updatingExistingCreditCard", false

      false

    updatingExistingCreditCard: ->
      @set "updatingExistingCreditCard", true

      Ember.run.next =>
        @$('#card-number').focus()

      false

  tagName: 'fieldset'
  classNameBindings: [':form-horizontal']

  showExistingCreditCard: Ember.computed 'hasGatewayAccount', 'updatingExistingCreditCard', ->
    if @get('updatingExistingCreditCard')
      return false

    if @get('hasGatewayAccount')
      return true

    return false

  organisationView: Ember.TextField.extend Radium.ValueValidationMixin,
    viewName: 'organizationName'
    valueBinding: 'targetObject.organisation'

  updatingExistingCreditCard: false

  billingEmailView: Ember.TextField.extend
    classNameBindings: ['isInvalid', 'isValid', ':field']
    valueBinding: 'targetObject.billingEmail'

    isInvalid: Ember.computed 'value', 'targetObject.isSubmitted', ->
      value = @get('value')
      target = @get('targetObject')
      target.get('isSubmitted') && (Ember.isEmpty(value) || !target.emailIsValid(value))

    isValid: Ember.computed 'isInvalid', ->
      not @get('isInvalid')
