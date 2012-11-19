Radium.Todo = Radium.Core.extend Radium.CommentsMixin,
  isEditable: true
  hasAnimation: false
  kind: DS.attr('todoKind')
  description: DS.attr('string')
  finishBy: DS.attr('datetime')
  finished: DS.attr('boolean')
  overdue: DS.attr('boolean')

  reference: Radium.polymorphic('reference')
  referenceType: (-> @get('referenceData.type') ).property('referenceData.type')
  referenceData: DS.attr('object')

  user: DS.belongsTo('Radium.User')
  contact: DS.belongsTo('Radium.Contact')
  # Turn on when todo's are created from the form
  hasNotificationAnim: DS.attr('boolean')

  isCall: ( ->
    (if (@get('kind') is 'call') then true else false)
  ).property('kind')

  isDueToday: ( ->
    today = Ember.DateTime.create()
    finishBy = @get('finishBy')
    Ember.DateTime.compareDate(today, finishBy) is 0
  ).property('finishBy')

  canComplete: (->
    !!@get('user.apiKey')
  ).property('user')

  feedDate: (-> @get 'finishBy' ).property('finishBy')

  associatedContacts: Radium.defineFeedAssociation(Radium.Contact, 'reference')
  associatedUsers: Radium.defineFeedAssociation(Radium.User, 'user')
  associatedGroups: Radium.defineFeedAssociation(Radium.Group, 'reference')
