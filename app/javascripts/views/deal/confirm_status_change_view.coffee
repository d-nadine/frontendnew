require 'lib/radium/modal_view'

Radium.DealConfirmStatusChangeView = Radium.ModalView.extend
  lostBecause: Radium.TextArea.extend(Ember.TargetActionSupport,
    classNameBindings: ['isValid', 'isInvalid', ':new-comment']
    placeholder: 'Supply a reason why this deal was lost.'
    valueBinding: 'targetObject.lostBecause'
    isLost: Ember.computed.alias 'targetObject.isLost'

    isValid: Ember.computed 'value', 'targetObject.isSubmitted', 'targetObject.isLost', ->
      return unless @get('isLost')
      @get('value.length')

    isInvalid: Ember.computed 'value', 'targetObject.isSubmitted', 'targetObject.isLost', ->
      return unless @get('targetObject.isSubmitted')
      not @get('isValid')
    )
