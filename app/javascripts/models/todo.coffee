Radium.Todo = Radium.Core.extend Radium.CommentsMixin,
  kind: DS.attr('string')
  description: DS.attr('string')
  finishBy: DS.attr('datetime')
  finished: DS.attr('boolean')
  overdue: DS.attr('boolean')

  reference: Radium.polymorphicAttribute()
  referenceType: (-> @get('referenceData.type') ).property('referenceData.type')
  referenceData: DS.attr('object')

  # polymorphic types
  contact: DS.belongsTo('Radium.Contact', polymorphicFor: 'reference')
  todo: DS.belongsTo('Radium.Todo', polymorphicFor: 'reference', inverse: 'todos')
  meeting: DS.belongsTo('Radium.Meeting', polymorphicFor: 'reference')
  group: DS.belongsTo('Radium.Group', polymorphicFor: 'reference')
  deal: DS.belongsTo('Radium.Deal', polymorphicFor: 'reference')
  phone_call: DS.belongsTo('Radium.PhoneCall', polymorphicFor: 'reference')
  email: DS.belongsTo('Radium.Email', polymorphicFor: 'reference')

  todos: DS.hasMany('Radium.Todo', inverse: 'todo')
  user: DS.belongsTo('Radium.User')

  isCall: ( ->
    (if (@get('kind') is 'call') then true else false)
  ).property('kind')

  isDueToday: ( ->
    today = Ember.DateTime.create()
    finishBy = @get('finishBy')
    Ember.DateTime.compareDate(today, finishBy) is 0
  ).property('finishBy')

  canComplete: (->
    !!@get('user.apiKey')
  ).property('user')

  feedDate: (-> 
    @get 'finishBy'
  ).property('finishBy')
