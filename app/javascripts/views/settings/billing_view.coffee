require 'lib/radium/value_validation_mixin'

Radium.SettingsBillingView = Radium.View.extend
  actions:
    createTokenAndSubmit: ->
      controller = @get('controller')

      controller.set 'isPersisting', true

      controller.set('isSubmitted', true)

      unless controller.get('isValid')
        controller.set 'isPersisting', false
        $.scrollTo 0, 500, { easing:'swing', queue:true, axis:'xy' }
        return

      stripeResponseHandler = (status, response) =>
        if response.error
          controller.send 'flashError', response.error.message
        else
          controller.set 'token', response.id
          controller.send 'update'

      # test credit card number #4242424242424242
      Stripe.card.createToken
        number: $('#card-number').val(),
        cvc: $('#card-cvc').val(),
        exp_month: $('#card-expiry-month').val(),
        exp_year: $('#card-expiry-year').val()
      , stripeResponseHandler
      false

  organisationView: Ember.TextField.extend Radium.ValueValidationMixin,
    valueBinding: 'targetObject.organisation'

  billingInfoView: Ember.TextField.extend
    valueBinding: 'targetObject.billingEmail'
    classNameBindings: ['isInvalid', 'isValid', ':field']
    isInvalid: (->
      value = @get('value')
      target = @get('targetObject')
      target.get('isSubmitted') && (Ember.isEmpty(value) || !target.emailIsValid(value))
    ).property('value', 'targetObject.isSubmitted')
    isValid: (->
      not @get('isInvalid')
    ).property('value', 'targetObject.isSubmitted')
