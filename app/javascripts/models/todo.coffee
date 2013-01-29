Radium.Todo = Radium.Core.extend Radium.CommentsMixin,
  kind: DS.attr('string')
  description: DS.attr('string')
  finishBy: DS.attr('datetime')
  finished: DS.attr('boolean')
  overdue: DS.attr('boolean')

  reference: DS.attr('object')
  user: DS.belongsTo('Radium.User')

  isCall: ( ->
    (if (@get('kind') is 'call') then true else false)
  ).property('kind')

  isDueToday: ( ->
    today = Ember.DateTime.create()
    finishBy = @get('finishBy')
    Ember.DateTime.compareDate(today, finishBy) is 0
  ).property('finishBy')
