require 'lib/radium/value_validation_mixin'

Radium.BillingFormView = Radium.View.extend
  actions:
    createTokenAndSubmit: ->
      controller = @get('targetObject')

      controller.set 'isPersisting', true

      controller.set('isSubmitted', true)

      unless controller.get('isValid')
        controller.set 'isPersisting', false
        $.scrollTo 0, 500, { easing:'swing', queue:true, axis:'xy' }
        return

      stripeResponseHandler = (status, response) =>
        if response.error
          @controller.set 'isPersisting', false
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

  setUp: ( ->
    Ember.run.scheduleOnce 'afterRender', 'this', =>
      @$().slideDown 'slow', =>
        unless organisationName = @get("organisationName")?.$()
          return

        organisationName.focus()
  ).on 'didInsertElement'

  teardown: ( ->
    clone = this.$().clone()
    @$().parent().prepend(clone)
    clone.slideUp 'slow', =>
      clone.remove()
  ).on 'willDestroyElement'

  classNameBindings: [':form-horizontal', ':hide']
  templateName: 'billing/billing_form'

  organisationView: Ember.TextField.extend Radium.ValueValidationMixin,
    viewName: 'organizationName'
    valueBinding: 'targetObject.organisation'

  billingInfoView: Ember.TextField.extend
    valueBinding: 'targetObject.billingEmail'
    classNameBindings: ['isInvalid', 'isValid', ':field']

    isInvalid: Ember.computed 'value', 'targetObject.isSubmitted', ->
      value = @get('value')
      target = @get('targetObject')
      target.get('isSubmitted') && (Ember.isEmpty(value) || !target.emailIsValid(value))

    isValid: Ember.computed 'isInvalid', ->
      not @get('isInvalid')
