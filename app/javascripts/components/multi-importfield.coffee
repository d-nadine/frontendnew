Radium.MultiImportfieldComponent = Ember.Component.extend
  actions:
    removeField: (field) ->
      @sendAction 'removeField', field

  classNames: ['multi-import']

  autocomplete: Radium.Combobox.extend
    classNames: ['field']
    sourceBinding: 'controller.source'
    sortedSource: Ember.computed.alias 'source'

  uniqueRadioName: ( ->
    @get('elementId') + 'type'
  ).property()
