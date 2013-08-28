require 'lib/radium/value_validation_mixin'

Radium.SettingsBillingView = Radium.View.extend
  organisationView: Ember.TextField.extend Radium.ValueValidationMixin,
    valueBinding: 'controller.organisation'

  billingInfoView: Ember.TextField.extend Radium.ValueValidationMixin,
    valueBinding: 'controller.billingEmail'

  createTokenAndSubmit: ->
    controller = @get('controller')

    controller.set('isSubmitted', true)

    return unless controller.get('isValid')

    stripeResponseHandler = (status, response) =>
      if response.error
        controller.send 'flashError', response.error.message
      else
        controller.set 'token', response.id
        controller.update()

    Stripe.card.createToken
      number: $('#card-number').val(),
      cvc: $('#card-cvc').val(),
      exp_month: $('#card-expiry-month').val(),
      exp_year: $('#card-expiry-year').val()
    , stripeResponseHandler
    false
