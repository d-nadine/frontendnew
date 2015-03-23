Radium.MultiImportfieldComponent = Ember.Component.extend
  actions:
    removeField: (field) ->
      @sendAction 'removeField', field

  classNames: ['multi-import']

  uniqueRadioName: Ember.computed ->
    @get('elementId') + 'type'
