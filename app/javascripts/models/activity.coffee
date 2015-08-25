require 'models/note'

Radium.Activity = Radium.Model.extend Radium.CommentsMixin,
  users: DS.hasMany('Radium.User')
  contacts: DS.hasMany('Radium.Contact')
  companies: DS.hasMany('Radium.Company')

  user: DS.belongsTo('Radium.User', inverse: 'activities')

  note: DS.belongsTo('Radium.Note')

  tag: DS.attr('string')
  event: DS.attr('string')
  meta: DS.attr('object')
  time: DS.attr('datetime')
  source: DS.attr('string')
  external: DS.attr('boolean')
  externalLink: DS.attr('string')

  todo: DS.belongsTo('Radium.Todo')

  reference: Ember.computed '_referenceAttachment','_referenceCompany','_referenceContact','_referenceDeal','_referenceEmail','_referenceMeeting','_referenceTodo','_referenceInvitation', (key, value) ->
      if arguments.length == 2 && value
        property = value.constructor.toString().split('.')[1]
        associationName = "_reference#{property}"
        @set associationName, value
      else
        @get('_referenceAttachment') ||
          @get('_referenceCompany') ||
          @get('_referenceContact') ||
          @get('_referenceDeal') ||
          @get('_referenceEmail') ||
          @get('_referenceMeeting') ||
          @get('_referenceTodo') ||
          @get('_referenceInvitation')

  _referenceAttachment: DS.belongsTo('Radium.Attachment')
  _referenceCompany: DS.belongsTo('Radium.Company')
  _referenceContact: DS.belongsTo('Radium.Contact')
  _referenceDeal: DS.belongsTo('Radium.Deal')
  _referenceEmail: DS.belongsTo('Radium.Email')
  _referenceMeeting: DS.belongsTo('Radium.Meeting')
  _referenceTodo: DS.belongsTo('Radium.Todo')
  _referenceInvitation: DS.belongsTo('Radium.Invitation')
