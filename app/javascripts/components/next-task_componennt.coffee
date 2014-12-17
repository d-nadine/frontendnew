Radium.NextTaskComponent = Ember.Component.extend
  actions:
    addTodo: (period) ->
      p period

    toggleTaskMenu: ->
      el = @$()

      el.toggleClass('open')

  classNames: ["dd", "dropdown"]