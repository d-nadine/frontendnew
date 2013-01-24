require 'radium/groupable'

Radium.NotificationsController = Ember.ArrayController.extend Radium.Groupable,
  count: (->
    reminders = @get('reminders.length') || 0
    reminders + @get('length')
  ).property('reminders.length', 'length')

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

  groupBy: (item) ->
    item.get('referenceType')

  groupType: Em.ArrayProxy.extend
    humanName: (->
      groupId = @get('groupId')
      groupId.humanize().capitalize().pluralize()
    ).property('groupId')
