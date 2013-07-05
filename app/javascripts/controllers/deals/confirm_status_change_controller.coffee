require 'lib/radium/modal_view'

Radium.DealConfirmStatusChangeController = Radium.ObjectController.extend
  isSubmitted: false

  isLost: (->
    @get('status') == 'lost'
  ).property('status')

  isValid: ( ->
    return false unless @get('isSubmitted')
    return true unless @get('isLost')

    @get('lostBecause.length')
  ).property('lostBecause', 'isSubmitted', 'isLost')

  confirm: ->
    @set 'isSubmitted', true
    return unless @get('isValid')
    @send 'confirmStatusChange'
