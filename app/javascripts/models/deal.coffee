Radium.Deal = DS.Model.extend Radium.CommentsMixin, 
  Radium.FollowableMixin, 
  Radium.AttachmentsMixin, 
  Radium.HasTasksMixin,

  todos: DS.hasMany('Radium.Todo')
  meetings: DS.hasMany('Meetings')

  contact: DS.belongsTo('Radium.Contact')
  user: DS.belongsTo('Radium.User')

  name: DS.attr('string')
  description: DS.attr('string')
  payBy: DS.attr('datetime')
  value: DS.attr('number')
  reason: DS.attr('string')

  lastStatus: DS.attr('string')
  status: DS.attr('string')

  isPastPayment: Radium.computed.isPast("payBy")

  tasks: Ember.computed.alias('todos')
