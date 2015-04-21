Radium.ToggleSwitchComponent = Ember.Component.extend
  classNames: ['toggle-switch']

  setup: Ember.on 'init', ->
    @on 'change', this, @_updateElementValue

  checkBoxId: Ember.computed ->
    "checker-#{@get('elementId')}"

  _updateElementValue: ->
    @sendAction()

    return if @get('dontPropagate')

    @set 'checked', @$('input').prop('checked')
