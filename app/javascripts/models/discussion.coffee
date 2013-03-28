Radium.Discussion = Radium.Model.extend Radium.CommentsMixin,
  Radium.AttachmentsMixin,
  Radium.HasTasksMixin,

  users: DS.hasMany('Radium.User')

  todos: DS.hasMany('Radium.Todo')
  meetings: DS.hasMany('Radium.Meeting')

  user: DS.belongsTo('Radium.User', inverse: null)
  deal: DS.belongsTo('Radium.Deal', inverse: null)
  contact: DS.belongsTo('Radium.Contact', inverse: null)

  topic: DS.attr('string')

  reference: ((key, value) ->
    if arguments.length == 2 && value
      property = value.constructor.toString().split('.')[1].toLowerCase()
      @set property, value
    else
      @get('deal') || @get('contact')
  ).property('deal', 'contact')

  tasks: Radium.computed.tasks('todos', 'meetings')
