Radium.Deal = DS.Model.extend Radium.CommentsMixin,
  Radium.FollowableMixin,
  Radium.AttachmentsMixin,
  Radium.HasTasksMixin,

  todos: DS.hasMany('Radium.Todo')
  calls: DS.hasMany('Radium.Call')
  meetings: DS.hasMany('Meetings')

  contact: DS.belongsTo('Radium.Contact')
  user: DS.belongsTo('Radium.User')
  email: DS.belongsTo('Radium.Email')
  todo: DS.belongsTo('Radium.Todo')
  checklist: DS.belongsTo('Radium.Checklist')
  isPublished: DS.attr('boolean')

  reference: ((key, value) ->
    if arguments.length == 2 && value != undefined
      property = value.constructor.toString().split('.')[1].toLowerCase()
      @set property, value
    else
      @get('contact') || @get('deal') || @get('email')
  ).property('contact', 'deal', 'email')


  name: DS.attr('string')
  description: DS.attr('string')
  payBy: DS.attr('datetime')
  value: DS.attr('number')
  reason: DS.attr('string')

  lastStatus: DS.attr('string')
  status: DS.attr('string')

  isPastPayment: Radium.computed.isPast("payBy")

  tasks: Radium.computed.tasks('todos', 'calls', 'meetings')
