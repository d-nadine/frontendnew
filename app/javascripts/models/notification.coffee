Radium.Notification = Radium.Model.extend
  tag: DS.attr('string')
  event: DS.attr('string')
  time: DS.attr('datetime')
  read: DS.attr('boolean')
  user: DS.belongsTo('Radium.User')
  sentBy: DS.belongsTo('Radium.User')

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
        @get('_referenceMeeting') ||
        @get('_referenceCompany') ||
        @get('_referenceInvitation') ||
        @get('_referenceTodo') ||
        @get('_referenceCall') ||
        @get('_referenceMeeting')
  ).property('_referenceContact', '_referenceDeal', '_referenceDiscussion', '_referenceEmail', '_referenceMeeting')
  _referenceContact: DS.belongsTo('Radium.Contact')
  _referenceDeal: DS.belongsTo('Radium.Deal')
  _referenceDiscussion: DS.belongsTo('Radium.Discussion')
  _referenceEmail: DS.belongsTo('Radium.Email')
  _referenceMeeting: DS.belongsTo('Radium.Meeting')
  _referenceCompany: DS.belongsTo('Radium.Company')
  _referenceInvitation: DS.belongsTo('Radium.UserInvitation')
  _referenceTodo: DS.belongsTo('Radium.Todo')
  _referenceCall: DS.belongsTo('Radium.Call')
  _referenceMeeting: DS.belongsTo('Radium.Meeting')
