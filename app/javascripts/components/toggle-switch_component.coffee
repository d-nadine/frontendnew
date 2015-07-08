Radium.ToggleSwitchComponent = Ember.Component.extend
  classNames: ['toggle-switch']

  dataOn: "On"
  dataOff: "Off"

  _init: Ember.on 'init', ->
    @on 'change', this, @_updateElementValue

  _teardown: Ember.on 'willDestroyElement', ->
    @off 'change'

  checkBoxId: Ember.computed ->
    "checker-#{@get('elementId')}"

  _updateElementValue: ->
    @sendAction()

    return if @get('dontPropagate')

    @set 'checked', @$('input').prop('checked')
