Radium.Todo = Radium.Model.extend Radium.CommentsMixin,
  Radium.AttachmentsMixin,

  user: DS.belongsTo('Radium.User')

  description: DS.attr('string')
  finishBy: DS.attr('datetime')
  isFinished: DS.attr('boolean')

  displayName: Ember.computed.alias 'description'

  reference: Ember.computed '_referenceContact', '_referenceDeal', '_referenceDiscussion', '_referenceEmail', '_referenceMeeting', '_referenceTodo', '_referenceCompany', (key, value) ->
    if arguments.length == 2 && value != undefined
      property = value.constructor.toString().split('.')[1]
      associationName = "_reference#{property}"
      return if @get(associationName) == undefined
      @set associationName, value
    else
      @get('_referenceCompany') ||
      @get('_referenceContact') ||
      @get('_referenceDeal') ||
      @get('_referenceDiscussion') ||
      @get('_referenceEmail') ||
      @get('_referenceMeeting') ||
      @get('_referenceTodo')

  _referenceContact: DS.belongsTo('Radium.Contact')
  _referenceDeal: DS.belongsTo('Radium.Deal')
  _referenceDiscussion: DS.belongsTo('Radium.Discussion')
  _referenceEmail: DS.belongsTo('Radium.Email')
  _referenceMeeting: DS.belongsTo('Radium.Meeting', inverse: 'todos')
  _referenceTodo: DS.belongsTo('Radium.Todo', inverse: 'todos')
  _referenceCompany: DS.belongsTo('Radium.Company')

  activities: DS.hasMany('Radium.Activity', inverse: '_referenceTodo')

  todos: DS.hasMany('Radium.Todo', inverse: null)
  notes: DS.hasMany('Radium.Note', inverse: '_referenceTodo')
  tasks: Radium.computed.tasks('todos')

  overdue: Ember.computed 'finishBy', ->
    return false if @get('isFinished')

    @get('finishBy').isBeforeToday()

  time: Ember.computed.alias('finishBy')

  toString: ->
    @get 'description'

  clearRelationships: ->
    @get('activities').compact().forEach (activity) ->
      activity.deleteRecord()

    @get('tasks').compact().forEach (task) ->
      task.deleteRecord()

    @get('todos').compact().forEach (todo) ->
      todo.unloadRecord()

    Radium.Notification.all().compact().forEach (notification) ->
      if notification.get('_referenceTodo') == this
        notification.deleteRecord()
