Radium.InboxView = Em.View.extend
  templateName: 'radium/inbox/inbox'
  contentBinding: 'controller.content'
  arrow: Em.View.extend
    classNames: 'arrow'
    isVisible: ( ->
      @get('parentView.controller.length') > 0
    ).property('parentView.controller.length')
