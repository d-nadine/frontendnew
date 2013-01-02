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
        templateName: "radium/notifications/#{tag.replace('.', '_')}"
      }

      view = @get('itemViewClass').create options
      @set 'currentView', view
  ).observes('content', 'content.tag')

  init: ->
    @_super()
    @contentDidChange()

  itemViewClass: Ember.View.extend
    tagName: 'div'
    layoutName: 'radium/layouts/notification_panel_item'
    referenceBinding: 'content.reference'

    isMeetingInvite: (->
      @get('content.tag') == 'invited.meeting'
    ).property('content.tag')
