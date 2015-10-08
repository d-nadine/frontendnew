Radium.ImportHeaderComponent = Ember.Component.extend
  classNames: ['item']

  previewLeader: Ember.computed 'value', ->
    unless value = @get('value')
      return

    index = @get('source').indexOf value

    @get('row')[index].get('name')
