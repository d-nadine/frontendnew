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
  plan: Ember.computed.alias 'currentUser.account.billingInfo.subscription'
  emailIsValid: (email) ->
    /^([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/.test email

Radium.ArrayController = Ember.ArrayController.extend ControllerMixin
Radium.Controller = Ember.Controller.extend ControllerMixin

Radium.ObjectController = Ember.ObjectController.extend ControllerMixin,
  resetModel: ->
    model = @get('model')

    Ember.assert 'resetModel called with no model', model

    model.reset()
requireAll /controllers/
