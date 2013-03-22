Radium.Attachment = Radium.Model.extend
  deal: DS.belongsTo('Radium.Deal')
  discussion: DS.belongsTo('Radium.Discussion')

  url: DS.attr('string')
  mimeType: DS.attr('string')
  name: DS.attr('string')

  attachable: ((key, value) ->
    if arguments.length == 2 && value
      property = value.constructor.split('.')[1].toLowerCase()
      @set property, value
    else
      @get('discussion') || @get('deal')
  ).property()
