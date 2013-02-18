Radium.Todo = Radium.Model.extend Radium.CommentsMixin,
  Radium.AttachmentsMixin,

  kind: DS.attr('string')
  description: DS.attr('string')
  finishBy: DS.attr('datetime')
  isFinished: DS.attr('boolean')

  # FIXME: this should be a computed property
  overdue: DS.attr('boolean')

  reference: DS.attr('object')
  user: DS.belongsTo('Radium.User')

  time: Ember.computed.alias('finishBy')

  # TODO: replace with a computed alias
  isCall: ( ->
    (if (@get('kind') is 'call') then true else false)
  ).property('kind')

  # TODO: replace with a computed alias
  isDueToday: ( ->
    today = Ember.DateTime.create()
    finishBy = @get('finishBy')
    Ember.DateTime.compareDate(today, finishBy) is 0
  ).property('finishBy')
