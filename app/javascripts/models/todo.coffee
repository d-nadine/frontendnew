Radium.Todo = Radium.Model.extend Radium.CommentsMixin,
  Radium.AttachmentsMixin,
  Radium.HasTasksMixin,

  user: DS.belongsTo('Radium.User')

  description: DS.attr('string')
  finishBy: DS.attr('datetime')
  isFinished: DS.attr('boolean')

  contact: DS.belongsTo('Radium.Contact')
  deal: DS.belongsTo('Radium.Deal')
  email: DS.belongsTo('Radium.Email')
  discussion: DS.belongsTo('Radium.Discussion')
  todo: DS.belongsTo('Radium.Todo')
  meeting: DS.belongsTo('Radium.Meeting')

  todos: DS.hasMany('Radium.Todo')
  meetings: DS.hasMany('Radium.Meeting')

  tasks: Radium.computed.tasks('todos', 'calls', 'meetings')

  reference: ((key, value) ->
    if arguments.length == 2 && value != undefined
      property = value.constructor.toString().split('.')[1].toLowerCase()
      @set property, value
    else
      @get('contact') || @get('deal') || @get('email')
  ).property('contact', 'deal', 'email')

  # FIXME: this should be a computed property
  overdue: DS.attr('boolean')

  time: Ember.computed.alias('finishBy')

  # TODO: replace with a computed alias
  isDueToday: ( ->
    today = Ember.DateTime.create()
    finishBy = @get('finishBy')
    Ember.DateTime.compareDate(today, finishBy) is 0
  ).property('finishBy')

  toString: ->
    @get 'description'
