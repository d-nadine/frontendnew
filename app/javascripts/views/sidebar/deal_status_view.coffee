Radium.SidebarDealStatusView = Radium.InlineEditorView.extend
  classNameBindings: [':deal-status']
  statusSelect: Ember.Select.extend
    contentBinding: 'controller.statuses'
    valueBinding: 'controller.form.status'
    disabledBinding: 'controller.statusDisabled'

  lostBecause: Radium.TextArea.extend(Ember.TargetActionSupport,
    classNameBindings: ['isValid', 'isInvalid']
    placeholder: 'Supply a reason why this deal was lost.'
    valueBinding: 'controller.lostBecause'
    isLost: Ember.computed.alias 'controller.isLost'
    classNames: ['new-comment']
    isValid: (->
      return unless @get('isLost')
      @get('value.length')
    ).property('value', 'controller.isSubmitted', 'controller.isLost')
    isInvalid: ( ->
      return unless @get('controller.isSubmitted')
      not @get('isValid')
    ).property('value', 'controller.isSubmitted', 'controller.isLost')
  )


