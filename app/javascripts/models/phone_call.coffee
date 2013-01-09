Radium.PhoneCall = Radium.Core.extend Radium.CommentsMixin,
  outcome: DS.attr('string')
  duration: DS.attr('number')
  kind: DS.attr('string')
  dialedAt: DS.attr('datetime')
  endedAt: DS.attr('datetime')

  to: Radium.polymorphicAttribute()
  from: Radium.polymorphicAttribute()

  toUser: DS.belongsTo('Radium.User', polymorphicFor: 'to')
  toContact: DS.belongsTo('Radium.Contact', polymorphicFor: 'to')

  fromUser: DS.belongsTo('Radium.User', polymorphicFor: 'from')
  fromContact: DS.belongsTo('Radium.Contact', polymorphicFor: 'from')

  todos: DS.hasMany('Radium.Todo', inverse: 'phone_call')
