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
  reference: DS.belongsTo('Radium.Contact', key: 'reference_id')
  user: DS.belongsTo('Radium.User', key: 'user_id')
  # Turn on when todo's are created from the form
  hasNotificationAnim: DS.attr('boolean')
  isDueToday: ( ->
    today = Ember.DateTime.create()
    finishBy = @get('finishBy')
    Ember.DateTime.compareDate(today, finishBy) is 0
  ).property('finishBy')
