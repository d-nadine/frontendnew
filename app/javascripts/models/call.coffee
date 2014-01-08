Radium.Call = Radium.Model.extend Radium.CommentsMixin,
  Radium.AttachmentsMixin,

  user: DS.belongsTo('Radium.User')

  description: DS.attr('string')
  finishBy: DS.attr('datetime')
  isFinished: DS.attr('boolean')

  contact: DS.belongsTo('Radium.Contact')

  reference: ((key, value) ->
    if arguments.length == 2 && value != undefined
      property = value.constructor.toString().split('.')[1]
      associationName = "_reference#{property}"
      @set associationName, value
    else
      @get('_referenceContact') ||
        @get('_referenceDeal') ||
        @get('_referenceDiscussion') ||
        @get('_referenceEmail') ||
        @get('_referenceMeeting')
  ).property('_referenceContact', '_referenceDeal', '_referenceDiscussion', '_referenceEmail', '_referenceMeeting')
  _referenceContact: DS.belongsTo('Radium.Contact')
  _referenceDeal: DS.belongsTo('Radium.Deal')
  _referenceDiscussion: DS.belongsTo('Radium.Discussion')
  _referenceEmail: DS.belongsTo('Radium.Email')
  _referenceMeeting: DS.belongsTo('Radium.Meeting')

  activities: DS.hasMany('Radium.Activity', inverse: '_referenceCall')

  overdue: ( ->
    now = Ember.DateTime.create()

    (@get('finishBy') < now)  && (!@get('isFinished'))
  ).property('finishBy')

  time: Ember.computed.alias('finishBy')

  toString: ->
    @get 'description'

  clearRelationships: ->
    @get('activities').compact().forEach (activity) =>
      activity.deleteRecord()

    Radium.Notification.all().compact().forEach (notification) =>
      if notification.get('_referenceCall') == this
        notification.deleteRecord()
