Radium.XSelectComponent = Ember.Component.extend(
  setup: Ember.on('init', ->
    @on 'change', this, @_updateElementValue
    return
  )
  checkBoxId: Ember.computed(->
    'checker-' + @elementId
  )
  _updateElementValue: ->
    @sendAction()
    @set 'checked', @$('input').prop('checked')
)