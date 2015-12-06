Radium.Todo = Radium.Model.extend Radium.CommentsMixin,
  Radium.AttachmentsMixin,

  user: DS.belongsTo('Radium.User')

  description: DS.attr('string')
  finishBy: DS.attr('datetime')
  isFinished: DS.attr('boolean')

  displayName: Ember.computed.alias 'description'

  reference: Ember.computed '_referenceContact', '_referenceDeal', '_referenceEmail', '_referenceMeeting', '_referenceTodo', '_referenceCompany', (key, value) ->
    if arguments.length == 2 && value != undefined
      property = value.constructor.toString().split('.')[1]
      associationName = "_reference#{property}"
      return if @get(associationName) == undefined
      @set associationName, value
    else
      @get('_referenceCompany') ||
      @get('_referenceContact') ||
      @get('_referenceDeal') ||
      @get('_referenceEmail') ||
      @get('_referenceMeeting') ||
      @get('_referenceTodo')

  _referenceContact: DS.belongsTo('Radium.Contact', inverse: 'todos')
  _referenceDeal: DS.belongsTo('Radium.Deal', inverse: 'todos')
  _referenceEmail: DS.belongsTo('Radium.Email')
  _referenceMeeting: DS.belongsTo('Radium.Meeting', inverse: 'todos')
  _referenceTodo: DS.belongsTo('Radium.Todo', inverse: 'todos')
  _referenceCompany: DS.belongsTo('Radium.Company')

  activities: DS.hasMany('Radium.Activity', inverse: '_referenceTodo')

  notes: DS.hasMany('Radium.Note', inverse: '_referenceTodo')
  tasks: Radium.computed.tasks('todos')

  overdue: Ember.computed 'finishBy', ->
    return false if @get('isFinished')

    @get('finishBy')?.isBeforeToday()

  time: Ember.computed.alias('finishBy')

  toString: ->
    @get 'description'

  clearRelationships: ->
    Radium.Activity.all()
      .compact()
      .filter((activity) =>
        activity.get('_referenceTodo') == this || activity.get('todo') == this
      )
      .compact()
      .forEach (activity) ->
        activity.unloadRecord()

    @get('tasks').compact().forEach (task) ->
      task.unloadRecord()

    @get('todos').compact().forEach (todo) ->
      todo.unloadRecord()

    Radium.Notification.all().compact().forEach (notification) ->
      if notification.get('_referenceTodo') == this
        notification.unloadRecord()
