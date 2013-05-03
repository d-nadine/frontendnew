Radium.Discussion = Radium.Model.extend Radium.CommentsMixin,
  Radium.AttachmentsMixin,
  Radium.HasTasksMixin,

  users: DS.hasMany('Radium.User')

  todos: DS.hasMany('Radium.Todo')
  calls: DS.hasMany('Radium.Call')

  user: DS.belongsTo('Radium.User', inverse: null)

  topic: DS.attr('string')

  reference: ((key, value) ->
    if arguments.length == 2 && value
      property = value.constructor.toString().split('.')[1].toLowerCase()
      @set property, value
    else
      @get('_referenceDeal') || @get('_referenceContact')
  ).property('_referenceDeal', '_referenceContact')
  _referenceDeal: DS.belongsTo('Radium.Deal', inverse: null)
  _referenceContact: DS.belongsTo('Radium.Contact', inverse: null)

  tasks: Radium.computed.tasks('todos', 'calls')
