Radium.UpDownComponent = Ember.Component.extend
  actions:
    move: (model, direction) ->
      @sendAction "move", model, direction

      false

  classNames: ['btn-group']
