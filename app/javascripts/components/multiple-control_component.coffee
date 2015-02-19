Radium.MultipleControlComponent = Ember.Component.extend Radium.ComponentContextHackMixin,
  actions:
    modelChanged: (object) ->
      @sendAction 'action', object
