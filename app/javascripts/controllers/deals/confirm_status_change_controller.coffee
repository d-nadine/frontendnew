require 'lib/radium/modal_view'

Radium.DealConfirmStatusChangeController = Radium.ObjectController.extend
  actions:
    confirm: ->
      @set 'isSubmitted', true
      return unless @get('isValid')
      @send 'confirmStatusChange', @get('model')

  isSubmitted: false

  isLost: Ember.computed 'status', ->
    @get('status') == 'lost'

  isValid: Ember.computed 'lostBecause', 'isSubmitted', 'isLost', ->
    return false unless @get('isSubmitted')
    return true unless @get('isLost')

    @get('lostBecause.length')
