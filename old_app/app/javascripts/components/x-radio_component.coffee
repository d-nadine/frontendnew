Radium.XRadioComponent = Ember.Component.extend
  sendNotification: ->
    @sendAction('action', @get('item'))

  checked: Ember.computed 'selection', 'value', ->
    @get('value') == @get('selection')

  change: (e) ->
    @set 'selection', @get('value')

    Ember.run.schedule('actions', this, 'sendNotification')

    Ember.run.next =>
      el = @$('input[type=radio]')

      return unless el && el.length

      el.prop('checked', @get('value') == @get('selection'))

  radioButtonId: Ember.computed ->
    "checker-#{@get('elementId')}"
