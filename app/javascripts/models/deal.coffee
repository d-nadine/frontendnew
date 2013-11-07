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

  contact: DS.belongsTo('Radium.Contact')
  user: DS.belongsTo('Radium.User')
  checklist: DS.hasMany('Radium.ChecklistItem')

  reference: ((key, value) ->
    if arguments.length == 2 && value != undefined
      property = value.constructor.toString().split('.')[1]
      associationName = "_reference#{property}"
      @set associationName, value
    else
      @get('_referenceEmail')
  ).property('_referenceEmail')
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

  isOpen: ( ->
    not ['lost', 'closed'].contains(@get('status'))
  ).property('status')

  isUnpublished: ( ->
    @get('status') == 'unpublished'
  ).property('status')

  clearRelationships: ->
    @get('contact.deals').removeObject(this) if @get('contact')

    @get('tasks').compact().forEach (task) =>
      task.deleteRecord()

    @get('activities').compact().forEach (activity) =>
      activity.deleteRecord()
