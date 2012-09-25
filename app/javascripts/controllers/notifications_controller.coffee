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

    Radium.store.commit()

  destroyItem: (item) ->
    item.deleteRecord()
    Radium.store.commit()

  confirm: (event) ->
    notification = event.view.content
    invitation = notification.get('reference')
    invitation.set('state', 'confirmed')

    observer = ->
      if invitation.get('isLoaded') &&
          !invitation.get('isSaving') &&
          invitation.get('state') == 'confirmed'

        invitation.removeObserver 'isLoaded', observer
        invitation.removeObserver 'isSaving', observer

        notification.deleteRecord()
        Radium.store.commit()

    invitation.addObserver 'isLoaded', observer
    invitation.addObserver 'isSaving', observer

    Radium.store.commit()

  decline: (event) ->
    notification = event.view.content
    invitation = notification.get('reference')
    invitation.set('state', 'rejected')

    observer = ->
      if invitation.get('isLoaded') &&
          !invitation.get('isSaving') &&
          invitation.get('state') == 'rejected'

        invitation.removeObserver 'isLoaded', observer
        invitation.removeObserver 'isSaving', observer

        notification.deleteRecord()
        Radium.store.commit()

    invitation.addObserver 'isLoaded', observer
    invitation.addObserver 'isSaving', observer

    Radium.store.commit()

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
