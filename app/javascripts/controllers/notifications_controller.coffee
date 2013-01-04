Radium.NotificationsController = Ember.ArrayController.extend
  isVisible: false

  count: (->
    messages = @get('messages.length') || 0
    reminders = @get('reminders.length') || 0
    messages + reminders + @get('length')
  ).property('messages.length', 'reminders.length', 'length')

  toggleNotifications: (event) ->
    @toggleProperty 'isVisible'
    false

  dismiss: (event) ->
    item = event.view.content
    @destroyItem item

  dismissAll: (event) ->
    collection = event.context
    # toArray() needs to be used to 'materialize' array and
    # not use RecordArray, otherwise, when we get to last item
    # it will already by null
    collection.toArray().forEach (item) ->
      item.deleteRecord()

    @get('store').commit()

  destroyItem: (item) ->
    item.deleteRecord()
    @get('store').commit()

  NotificationGroup: Em.ArrayProxy.extend
    humanName: (->
      groupId = @get('groupId')
      if groupId == 'invitation'
        'Meetings'
      else
        groupId.humanize().capitalize().pluralize()
    ).property('groupId')

  notificationGroups: (->
    if content = @get 'content'
      Ember.ArrayProxy.create(Radium.Groupable,
        content: content
        groupType: @get('NotificationGroup')
        groupBy: (item) ->
          item.get('referenceType')
      )
  ).property('content')
