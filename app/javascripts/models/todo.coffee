Radium.Todo = Radium.Model.extend Radium.CommentsMixin,
  Radium.AttachmentsMixin,
  Radium.HasTasksMixin,

  user: DS.belongsTo('Radium.User')

  description: DS.attr('string')
  finishBy: DS.attr('datetime')
  isFinished: DS.attr('boolean')

  todos: DS.hasMany('Radium.Todo')
  meetings: DS.hasMany('Radium.Meeting')

  tasks: Radium.computed.tasks('todos', 'calls', 'meetings')

  reference: ((key, value) ->
    if arguments.length == 2 && value != undefined
      property = value.constructor.toString().split('.')[1].toLowerCase()
      @set property, value
    else
      @get('_referenceContact') || @get('_referenceDeal') || @get('_referenceEmail') || @get('_referenceDiscussion') || @get('_referenceMeeting')
  ).property('contact', 'deal', 'email')
  _referenceContact: DS.belongsTo('Radium.Contact')
  _referenceDeal: DS.belongsTo('Radium.Deal')
  _referenceEmail: DS.belongsTo('Radium.Email')
  _referenceDiscussion: DS.belongsTo('Radium.Discussion')
  _referenceMeeting: DS.belongsTo('Radium.Meeting')

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
