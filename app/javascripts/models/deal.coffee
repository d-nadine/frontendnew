Radium.Deal = Radium.Model.extend Radium.AttachmentsMixin,
  Radium.HasTasksMixin,

  currentStatus: DS.belongsTo('Radium.ListStatus')
  list: DS.belongsTo('Radium.List')

  statusLastChangedAt: DS.attr('datetime')
  expectedCloseDate: DS.attr('datetime')
  user: DS.belongsTo('Radium.User')
  todos: DS.hasMany('Radium.Todo')
  meetings: DS.hasMany('Radium.Meeting')

  activities: DS.hasMany('Radium.Activity')

  contact: DS.belongsTo('Radium.Contact', inverse: 'deals')
  company: DS.belongsTo('Radium.Company', inverse: 'deals')

  contacts: DS.hasMany('Radium.Contact')

  contactRefs: DS.hasMany('Radium.ContactRef')

  name: DS.attr('string')
  description: DS.attr('string')
  payBy: DS.attr('datetime')
  value: DS.attr('number')

  nextTodo: DS.belongsTo('Radium.Todo', inverse: null)
  nextTask: Ember.computed 'nextTodo', ->
    @get('nextTodo')

  nextTaskDate: DS.attr('datetime')

  nextTaskDateDisplay: Ember.computed 'nextTaskDate', ->
    if nextDate = @get('nextTaskDate')
      nextDate.readableTimeAgo()

  tasks: Radium.computed.tasks('todos', 'meetings')

  displayName: Ember.computed.alias 'name'

  about: Ember.computed.alias 'description'

  reference: Ember.computed  '_reference',  (key, value) ->
    if arguments.length == 2 && value != undefined
      property = value.constructor.toString().split('.')[1]
      associationName = "_reference#{property}"
      @set associationName, value
    else
      @get('_referenceEmail')

  _referenceEmail: DS.belongsTo('Radium.Email')

  daysInCurrentState: Ember.computed 'statusLastChangedAt', ->
    unless lastChange = @get('statusLastChangedAt')
      return "N/A"

    now = Ember.DateTime.create()

    timeDiff = Math.ceil((now.get('milliseconds') - lastChange.get('milliseconds')) / (1000 * 60))

    if timeDiff <= 1
      return "A few seconds"
    else if timeDiff < 60
      return "#{timeDiff} minute(s)"
    else if timeDiff < (24 * 60)
      return "#{Math.floor(timeDiff / 60)} hour(s)"
    else
      return "#{Math.floor(timeDiff / (24 * 60))} day(s)"

  longName: Ember.computed 'name', 'contact', ->
    name = @get('name')
    return name unless @get('contact')

    suffix = if company = @get('contact.company')
               company.get('displayName')
             else
               @get('contact.displayName')

    "#{name} - #{suffix}"

  hasPrimaryContact: Ember.computed 'contact', ->
    @get('contact.id')

  clearRelationships: ->
    @get('contact.deals').removeObject(this) if @get('contact')

    @get('company.deals').removeObject(this) if @get('company')

    @get('tasks').compact().forEach (task) ->
      task.unloadRecord()

    @get('activities').compact().forEach (activity) ->
      activity.unloadRecord()

    @get('attachments').compact().forEach (attachment) ->
      attachment.unloadRecord()

    Radium.Notification.all().compact().forEach (notification) ->
      if notification.get('_referenceDeal') == this
        notification.unloadRecord()

    @_super.apply this, arguments
