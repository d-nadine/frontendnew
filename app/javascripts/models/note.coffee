Radium.Note = Radium.Model.extend Radium.CommentsMixin,
  user: DS.belongsTo('Radium.User')

  body: DS.attr('string')
  displayName: Ember.computed.alias 'body'
  notifications: DS.hasMany('Radium.Notification', inverse: '_referenceNote')


  reference: ((key, value) ->
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
  ).property('_referenceContact', '_referenceDeal', '_referenceDiscussion', '_referenceEmail', '_referenceMeeting', '_referenceTodo', '_referenceCompany')
  _referenceContact: DS.belongsTo('Radium.Contact', inverse: 'notes')
  _referenceDeal: DS.belongsTo('Radium.Deal')
  _referenceDiscussion: DS.belongsTo('Radium.Discussion')
  _referenceEmail: DS.belongsTo('Radium.Email')
  _referenceMeeting: DS.belongsTo('Radium.Meeting', inverse: 'notes')
  _referenceTodo: DS.belongsTo('Radium.Todo', inverse: 'notes')
  _referenceCompany: DS.belongsTo('Radium.Company')

  toString: ->
    @get 'body'

  clearRelationships: ->
    Radium.Notification.all().compact().forEach (notification) =>
      if notification.get('_referenceNote') == this
        notification.deleteRecord()
