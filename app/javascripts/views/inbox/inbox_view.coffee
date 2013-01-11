Radium.InboxView = Em.View.extend
  templateName: 'radium/inbox/inbox'

  didInsertElement: ->
    $('.email-action').dropdown()

  arrow: Em.View.extend
    classNames: 'arrow'
    isVisible: ( ->
      @get('parentView.controller.length') > 0
    ).property('parentView.controller.length')
