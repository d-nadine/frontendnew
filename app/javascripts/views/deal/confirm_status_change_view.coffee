require 'lib/radium/modal_view'

Radium.DealConfirmStatusChangeView = Radium.ModalView.extend
  lostBecause: Radium.TextArea.extend(Ember.TargetActionSupport,
    classNameBindings: ['isValid', 'isInvalid', ':new-comment']
    placeholder: 'Supply a reason why this deal was lost.'
    valueBinding: 'controller.lostBecause'
    isLost: Ember.computed.alias 'controller.isLost'
    isValid: (->
      return unless @get('isLost')
      @get('value.length')
    ).property('value', 'controller.isSubmitted', 'controller.isLost')
    isInvalid: ( ->
      return unless @get('controller.isSubmitted')
      not @get('isValid')
    ).property('value', 'controller.isSubmitted', 'controller.isLost')
  )
