Radium.Deal = Radium.Core.extend Radium.CommentsMixin,
  name: DS.attr('string')
  description: DS.attr('string')
  closeBy: DS.attr('datetime')

  todos: DS.hasMany('Radium.Todo', inverse: 'deal')

  # Can be `pending`, `closed`, `paid`, `rejected`
  state: DS.attr('string')
  isPublic: DS.attr('boolean')
  user: DS.belongsTo('Radium.User')
  isPending: (->
    @get('state') is 'pending'
  ).property('state')
  isClosed: (->
    @get('state') is 'closed'
  ).property('state')
  isPaid: (->
    @get('state') is 'paid'
  ).property('state')
  isRejected: (->
    @get('state') is 'rejected'
  ).property('state')

  isOverdue: (->
    d = new Date().getTime()
    closeBy = new Date(@get('closeBy')).getTime()
    (if (closeBy <= d) then true else false)
  ).property('closeBy')
