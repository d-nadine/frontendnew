Radium.MultipleBaseView = Radium.View.extend
  click: (evt) ->
    evt.stopPropagation()
    evt.preventDefault()

  primaryRadio: Radium.Radiobutton.extend
    leader: 'Make Primary'

    didInsertElement: ->
      @set('checked', true) if @get('controller.isPrimary')

    isChecked: Ember.computed.bool 'controller.isPrimary'

    click: (evt) ->
      evt.stopPropagation()
      @get('controller.parent').setEach('isPrimary', false)
      @set('controller.isPrimary', true)
