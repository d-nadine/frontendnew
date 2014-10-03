Radium.ToggleSwitchComponent = Ember.Component.extend
  classNames: ['toggle-switch']

  setup: (->
    @on 'change', this, @_updateElementValue
  ).on('init')

  checkBoxId: Ember.computed ->
    "checker-#{@get('elementId')}"

  _updateElementValue: ->
    @sendAction()

    return if @get('dontPropagate')

    @set 'checked', @$('input').prop('checked')
