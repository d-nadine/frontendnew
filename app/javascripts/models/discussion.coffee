Radium.Discussion = Radium.Model.extend Radium.CommentsMixin,
  Radium.AttachmentsMixin,
  Radium.HasTasksMixin,

  users: DS.hasMany('Radium.User')

  todos: DS.hasMany('Radium.Todo')
  calls: DS.hasMany('Radium.Call')

  user: DS.belongsTo('Radium.User')

  topic: DS.attr('string')

  reference: ((key, value) ->
    if arguments.length == 2 && value
      property = value.constructor.toString().split('.')[1]
      associationName = "_reference#{property}"
      @set associationName, value
    else
      @get('_referenceDeal') || @get('_referenceContact')
  ).property('_referenceDeal', '_referenceContact')
  _referenceContact: DS.belongsTo('Radium.Contact', inverse: null)
  _referenceDeal: DS.belongsTo('Radium.Deal', inverse: null)

  tasks: Radium.computed.tasks('todos', 'calls')

  time: Ember.computed.alias 'createdAt'
