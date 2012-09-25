# TODO: Add string parsing so the notification line item is more descriptive.
Radium.NotificationItemView = Ember.ContainerView.extend
  contentDidChange: (->
    tag = @get('content.tag')

    if tag && !@get('currentView')
      content = @get 'content'
      tagStrings = tag.split('.')
      action = tagStrings[0]
      referenceType = tagStrings[1]

      options = {
        content: content
        templateName: tag.replace('.', '_') + '_notification'
      }

      view = @get('itemViewClass').create options
      @set 'currentView', view
  ).observes('content', 'content.tag')

  init: ->
    @_super()
    @contentDidChange()

  click: ->
    reference = @get 'content.reference'
    Radium.Utils.showItem reference

  itemViewClass: Ember.View.extend
    tagName: 'div'
    layoutName: 'notification_panel_item_layout'
    referenceBinding: 'content.reference'

    isMeetingInvite: (->
      @get('content.tag') == 'invited.meeting'
    ).property('content.tag')
