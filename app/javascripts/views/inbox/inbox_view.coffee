Radium.InboxView = Em.View.extend
  templateName: 'radium/inbox/inbox'
  showNewMailDialog: ->
    console.log 'new mail'
  arrow: Em.View.extend
    classNames: 'arrow'
    isVisible: ( ->
      @get('parentView.controller.length') > 0
    ).property('parentView.controller.length')
    # isVisibleBinding: Em.Binding.bool('parentView.content.length')
