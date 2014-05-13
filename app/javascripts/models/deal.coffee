require 'lib/radium/checklist_total_mixin'

Radium.Deal = Radium.Model.extend Radium.FollowableMixin,
  Radium.AttachmentsMixin,
  Radium.HasTasksMixin,
  Radium.ChecklistTotalMixin,

  user: DS.belongsTo('Radium.User')
  todos: DS.hasMany('Radium.Todo')
  calls: DS.hasMany('Radium.Call')
  meetings: DS.hasMany('Radium.Meeting')

  activities: DS.hasMany('Radium.Activity')

  contact: DS.belongsTo('Radium.Contact', inverse: 'deals')
  user: DS.belongsTo('Radium.User')
  checklist: DS.hasMany('Radium.ChecklistItem')

  contacts: DS.hasMany('Radium.Contact')

  contactRefs: DS.hasMany('Radium.ContactRef')

  reference: Ember.computed  '_reference',  (key, value) ->
    if arguments.length == 2 && value != undefined
      property = value.constructor.toString().split('.')[1]
      associationName = "_reference#{property}"
      @set associationName, value
    else
      @get('_referenceEmail')

  _referenceEmail: DS.belongsTo('Radium.Email')

  name: DS.attr('string')
  description: DS.attr('string')
  payBy: DS.attr('datetime')
  value: DS.attr('number')

  lostDuring: DS.attr('string')
  lostBecause: DS.attr('string')
  status: DS.attr('string')

  isPastPayment: Radium.computed.isPast("payBy")

  tasks: Radium.computed.tasks('todos', 'calls', 'meetings')

  company: Ember.computed.alias('contact.company')

  displayName: Ember.computed.alias 'name'

  about: Ember.computed.alias 'description'

  isOpen: Ember.computed 'status', ->
    not ['lost', 'closed'].contains(@get('status'))

  isUnpublished: Ember.computed 'status', ->
    @get('status') == 'unpublished'

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

    @get('tasks').compact().forEach (task) =>
      task.deleteRecord()

    @get('activities').compact().forEach (activity) =>
      activity.deleteRecord()

    Radium.Notification.all().compact().forEach (notification) =>
      if @get('_referenceDeal') == this
        notification.deleteRecord()

    @_super.apply this, arguments
