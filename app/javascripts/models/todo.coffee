Radium.Todo = Radium.Core.extend Radium.CommentsMixin,
  isEditable: true
  hasAnimation: false
  kind: DS.attr('todoKind')
  description: DS.attr('string')
  finishBy: DS.attr('datetime',
    key: 'finish_by'
  )
  finished: DS.attr('boolean')
  isCall: ( ->
    (if (@get('kind') is 'call') then true else false)
  ).property('kind')
  overdue: DS.attr('boolean')
  # TODO: ideally it would be best to implement polymorphic belongsTo
  #       association
  reference: (->
    if type = @get('referenceType')
      type = Radium.Core.typeFromString(type)
      Radium.store.find type, @get('referenceId')
  ).property('referenceType', 'referenceId')
  referenceType: DS.attr('string', key: 'reference_type')
  referenceId: DS.attr('number', key: 'reference_id')

  user: DS.belongsTo('Radium.User', key: 'user_id')
  # Turn on when todo's are created from the form
  hasNotificationAnim: DS.attr('boolean')
  isDueToday: ( ->
    today = Ember.DateTime.create()
    finishBy = @get('finishBy')
    Ember.DateTime.compareDate(today, finishBy) is 0
  ).property('finishBy')
  canComplete: (->
    !!@get('user.apiKey')
  ).property('user')
