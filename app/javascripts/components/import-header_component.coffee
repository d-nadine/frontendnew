Radium.ImportHeaderComponent = Ember.Component.extend
  classNames: ['control-group', 'import-header']

  autocomplete: Radium.Combobox.extend
    classNames: ['field']
    sourceBinding: 'controller.source'
    sortedSource: Ember.computed.alias 'source'

  previewLeader: Ember.computed 'value', ->
    unless value = @get('value')
      return

    index = @get('source').indexOf value

    @get('row')[index].get('name')
