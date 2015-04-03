Radium.CustomfieldPickerComponent = Ember.Component.extend
  actions:
    modifyCustomFields: (item) ->
      if @get('isLastItem')
        @sendAction 'addNewCustomField'
      else
        @sendAction 'removeCustomField', @get('customField')

    changeCustomFieldType: (type) ->
      @set 'customField.type', type

      Ember.run.next =>
        @$('input:first').focus()

  customFieldTypes: Ember.A([
    "text",
    "date",
    "currency",
    "url",
    "dropdown"
  ])

  isSelect: Ember.computed.equal 'customField.type', 'dropdown'

  isLastItem: Ember.computed 'customField', 'lastItem', ->
    @get('customField') == @get('lastItem')
