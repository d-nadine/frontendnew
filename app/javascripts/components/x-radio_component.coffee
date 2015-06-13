Radium.XRadioComponent = Ember.Component.extend
  sendNotification: ->
    @sendAction('action', @get('item'))

  checked: Ember.computed 'selection', 'value', ->
    @get('value') == @get('selection')

  change: (e) ->
    @set 'selection', @get('value')

    Ember.run.schedule('actions', this, 'sendNotification')

  selectionDidChange: Ember.observer 'checked', ->
    Ember.run.next =>
      return unless el = @$()

      el.prop('checked', @get('checked'))

  radioButtonId: Ember.computed ->
    "checker-#{@get('elementId')}"
