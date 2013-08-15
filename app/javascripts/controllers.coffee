requireAll /mixins\/controllers/

ControllerMixin = Ember.Mixin.create Radium.CurrentUserMixin,
  needs: ['clock']
  clock: Ember.computed.alias('controllers.clock')
  tomorrow: Ember.computed.alias('clock.endOfTomorrow')
  now: Ember.computed.alias('clock.now')
  currentUser: Ember.computed.alias 'controllers.currentUser'
  isAdmin: Ember.computed.equal 'currentUser.model.isAdmin', true
  nonAdmin: Ember.computed.not 'isAdmin'

Radium.ArrayController = Ember.ArrayController.extend ControllerMixin
Radium.Controller = Ember.Controller.extend ControllerMixin

Radium.ObjectController = Ember.ObjectController.extend ControllerMixin,
  resetModel: ->
    model = @get('model')

    Ember.assert 'resetModel called with no model', model

    model.reset()

requireAll /controllers/
