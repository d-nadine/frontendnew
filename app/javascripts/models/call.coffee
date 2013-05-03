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
      @get('_referenceDeal') || @get('_referenceEmail')
  ).property('_referenceDeal', '_referenceEmail', '_referenceDiscussion')
  _referenceDiscussion: DS.belongsTo('Radium.Discussion')
  _referenceEmail: DS.belongsTo('Radium.Email')

  # FIXME: this should be a computed property
  overdue: DS.attr('boolean')

  time: Ember.computed.alias('finishBy')

  # TODO: replace with a computed alias
  isDueToday: ( ->
    today = Ember.DateTime.create()
    finishBy = @get('finishBy')
    Ember.DateTime.compareDate(today, finishBy) is 0
  ).property('finishBy')

  toString: ->
    @get 'description'
