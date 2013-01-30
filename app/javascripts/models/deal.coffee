Radium.Deal = Radium.Core.extend Radium.CommentsMixin,
  name: DS.attr('string')
  description: DS.attr('string')
  payBy: DS.attr('datetime')
  value: DS.attr('number')
  reason: DS.attr('string')

  # Can be `published`, `negotiating`, `closed`, `paymentpending`
  status: DS.attr('string')
  isPublic: DS.attr('boolean')

  todos: DS.hasMany('Radium.Todo', inverse: 'deal')
  meetings: DS.hasMany('Radium.Meeting')

  contact: DS.belongsTo('Radium.Contact')
  user: DS.belongsTo('Radium.User')

  isOverdue: (->
    d = new Date().getTime()
    payBy = new Date(@get('payBy')).getTime()
    (if (payBy <= d) then true else false)
  ).property('payBy')
