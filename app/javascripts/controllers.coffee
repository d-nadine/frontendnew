requireAll /mixins\/controllers/

ControllerMixin = Ember.Mixin.create Radium.CurrentUserMixin,
  needs: ['clock']
  clock: Ember.computed.alias('controllers.clock')
  tomorrow: Ember.computed.alias('clock.endOfTomorrow')
  now: Ember.computed.alias('clock.now')

Radium.ArrayController = Ember.ArrayController.extend ControllerMixin
Radium.ObjectController = Ember.ObjectController.extend ControllerMixin
Radium.Controller = Ember.Controller.extend ControllerMixin

requireAll /controllers/
