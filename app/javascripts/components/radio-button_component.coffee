Radium.RadioButtonComponent = Ember.Component.extend
  tagName: "input"
  type: "radio"
  attributeBindings: ['name', 'type', 'value', 'checked:checked']

  checked: Ember.computed 'selection', 'value', ->
    @get('value') == @get('selection')

  change: (e) ->
    @set 'selection', @get('value')

  selectionDidChange: Ember.observer 'checked', ->
    Ember.run.next =>
      this.$().prop('checked', @get('checked'))
