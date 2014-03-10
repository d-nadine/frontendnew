Radium.ImportHeaderComponent = Ember.Component.extend
  classNames: ['control-group']

  autocomplete: Radium.Combobox.extend
    classNames: ['field']
    sourceBinding: 'controller.source'

  previewLeader: Ember.computed 'value', ->
    unless value = @get('value')
      return

    index = @get('source').indexOf value

    @get('row')[index].get('name')
