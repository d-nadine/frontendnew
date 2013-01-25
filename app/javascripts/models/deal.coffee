Radium.Deal = Radium.Core.extend Radium.CommentsMixin,
  name: DS.attr('string')
  description: DS.attr('string')
  payBy: DS.attr('datetime')
  value: DS.attr('number')
  reason: DS.attr('string')

  todos: DS.hasMany('Radium.Todo', inverse: 'deal')
  meetings: DS.hasMany('Radium.Meeting')

  # Can be `published`, `negotiating`, `closed`, `paymentpending`
  status: DS.attr('string')
  isPublic: DS.attr('boolean')
  user: DS.belongsTo('Radium.User')
  contact: DS.belongsTo('Radium.Contact')

  feedDate: (->
    @get('payBy')
  ).property('payBy')

  isOverdue: (->
    d = new Date().getTime()
    payBy = new Date(@get('payBy')).getTime()
    (if (payBy <= d) then true else false)
  ).property('payBy')
