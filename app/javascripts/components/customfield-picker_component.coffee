Radium.CustomfieldPickerComponent = Ember.Component.extend
  actions:
    changeCustomFieldType: (type) ->
      @set('isSelect', type == 'Dropdown')

      Ember.run.next =>
        @$('input:first').focus()

  customFieldTypes: Ember.A([
    "Text",
    "Date",
    "$",
    "URL",
    "Dropdown"
  ])

  currentType: 'Text'

  isSelect: false
