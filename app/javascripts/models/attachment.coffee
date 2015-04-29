Radium.Attachment = Radium.Model.extend
  fileName: DS.attr('string')
  url: DS.attr('string')
  bucket: DS.attr('string')
  uploadedBy: DS.belongsTo('Radium.User')

  reference: ((key, value) ->
    if arguments.length == 2 && value
      property = value.constructor.split('.')[1].toLowerCase()
      @set property, value
    else
      @get('_referenceDeal') ||
      @get('_referenceEmail') ||
      @get('_referenceContact') ||
      @get('_referenceCompany') ||
      @get('_referenceMeeting') ||
      @get('_referenceTemplate')
  ).property('_referenceDeal', '_referenceEmail', '_referenceContact', '_referenceCompany')
  _referenceContact: DS.belongsTo('Radium.Contact')
  _referenceCompany: DS.belongsTo('Radium.Company')
  _referenceDeal: DS.belongsTo('Radium.Deal')
  _referenceEmail: DS.belongsTo('Radium.Email')
  _referenceMeeting: DS.belongsTo('Radium.Meeting')
  _referenceTemplate: DS.belongsTo('Radium.Template')
