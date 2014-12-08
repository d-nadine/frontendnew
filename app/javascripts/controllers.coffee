requireAll /mixins\/controllers/

ControllerMixin = Ember.Mixin.create Radium.CurrentUserMixin, Ember.Evented,
  actions:
    addErrorHandlersToModel: (model) ->
      model.one 'becameInvalid', (result) =>
        @send 'flashError', result
        model.reset()

      model.one 'becameError', =>
        @send 'flashError', 'An error has occurred and the meeting cannot be updated.'
        model.reset()

      false

  needs: ['clock', 'application']
  clock: Ember.computed.alias('controllers.clock')
  tomorrow: Ember.computed.alias('clock.endOfTomorrow')
  now: Ember.computed.alias('clock.now')
  currentUser: Ember.computed.alias 'controllers.currentUser.model'
  isAdmin: Ember.computed.bool 'currentUser.isAdmin', true
  nonAdmin: Ember.computed.not 'isAdmin'
  plan: Ember.computed.alias 'currentUser.account.billing.subscriptionPlan.planId'
  emailIsValid: (email) ->
    Radium.EMAIL_REGEX.test email

Radium.ArrayController = Ember.ArrayController.extend ControllerMixin
Radium.Controller = Ember.Controller.extend ControllerMixin

Radium.ObjectController = Ember.ObjectController.extend ControllerMixin,
  resetModel: ->
    model = @get('model')

    Ember.assert 'resetModel called with no model', model

    model.reset()
requireAll /controllers/
