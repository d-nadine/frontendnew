requireAll /mixins\/controllers/

ControllerMixin = Ember.Mixin.create Radium.CurrentUserMixin,
  needs: ['clock']
  clock: Ember.computed.alias('controllers.clock')
  tomorrow: Ember.computed.alias('clock.endOfTomorrow')
  now: Ember.computed.alias('clock.now')

Radium.ArrayController = Ember.ArrayController.extend ControllerMixin
Radium.Controller = Ember.Controller.extend ControllerMixin


Radium.ObjectController = Ember.ObjectController.extend ControllerMixin,
  resetModel: ->
    model = @get('model')

    Ember.assert 'resetModel called with no model', model

    state = if model.get('id')
              'loaded.updated.uncommitted'
            else
              'loaded.created.uncommited'

    model.get('transaction').rollback()
    model.get('stateManager').transitionTo(state)

requireAll /controllers/
