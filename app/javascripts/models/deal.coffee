require 'lib/radium/checklist_total_mixin'

Radium.Deal = DS.Model.extend Radium.CommentsMixin,
  Radium.FollowableMixin,
  Radium.AttachmentsMixin,
  Radium.HasTasksMixin,
  Radium.ChecklistTotalMixin,

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
  reason: DS.attr('string')

  lostDuring: DS.attr('string')
  lostBecause: DS.attr('string')
  status: DS.attr('string')

  isPastPayment: Radium.computed.isPast("payBy")

  tasks: Radium.computed.tasks('todos', 'calls', 'meetings')

  company: Ember.computed.alias('contact.company')

  isPublished: ( ->
    @get('status') == 'published'
  )
