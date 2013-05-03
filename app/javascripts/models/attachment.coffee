Radium.Attachment = Radium.Model.extend
  url: DS.attr('string')
  mimeType: DS.attr('string')
  name: DS.attr('string')

  attachable: ((key, value) ->
    if arguments.length == 2 && value
      property = value.constructor.split('.')[1].toLowerCase()
      @set property, value
    else
      @get('_attachableDiscussion') || @get('_attachableDeal') || @get('_attachableEmail')
  ).property('_attachableDiscussion', '_attachableDeal', '_attachableEmail')
  _attachableDeal: DS.belongsTo('Radium.Deal')
  _attachableEmail: DS.belongsTo('Radium.Email')
  _attachableDiscussion: DS.belongsTo('Radium.Discussion')
