Radium.XRadioComponent = Ember.Component.extend
  checked: Ember.computed 'selection', 'value', ->
    @get('value') == @get('selection')

  change: (e) ->
    @set 'selection', @get('value')

  selectionDidChange: Ember.observer 'checked', ->
    Ember.run.next =>
      @$().prop('checked', @get('checked'))

  radioButtonId: Ember.computed ->
    "checker-#{@get('elementId')}"
