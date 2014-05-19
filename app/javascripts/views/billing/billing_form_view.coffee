require 'lib/radium/value_validation_mixin'

Radium.BillingFormView = Radium.View.extend
  actions:
    createTokenAndSubmit: ->
      controller = @get('controller')

      controller.set 'isPersisting', true

      controller.set('isSubmitted', true)

      unless controller.get('isValid')
        controller.set 'isPersisting', false
        return

      stripeResponseHandler = (status, response) =>
        if response.error
          controller.set 'isPersisting', false
          controller.send 'flashError', response.error.message
        else
          Ember.$.scrollTo('.upgrade-plan', 800, {offset: - 100})
          controller.set 'token', response.id
          controller.send 'update'

      # test credit card number #4242424242424242
      # raise errors https://stripe.com/docs/testing
      # card declined 4000000000000002
      Stripe.card.createToken
        number: $('#card-number').val(),
        cvc: $('#card-cvc').val(),
        exp_month: $('#card-expiry-month').val(),
        exp_year: $('#card-expiry-year').val()
      , stripeResponseHandler
      false

    scrollToCard: ->
      Ember.$.scrollTo('.settings-group', 800, {offset: - 100})

  setUp: ( ->
    @get('controller').on('cardError', this, 'onCardError') if @get('controller').on

    Ember.run.scheduleOnce 'afterRender', 'this', =>
      @$().slideDown 'slow', =>
        unless organizationName = @get("organizationName")?.$()
          return

        organizationName.focus()
        @send 'scrollToCard'

  ).on 'didInsertElement'

  onCardError: ->
    @send 'scrollToCard'

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
