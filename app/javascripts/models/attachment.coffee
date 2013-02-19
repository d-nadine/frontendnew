typeMap = Ember.Map.create()

typeMap.set 'Radium.Discussion', 'discussion'
typeMap.set 'Radium.Deal', 'deal'

Radium.Attachment = Radium.Model.extend
  deal: DS.belongsTo('Radium.Deal')
  discussion: DS.belongsTo('Radium.Discussion')

  url: DS.attr('string')
  mimeType: DS.attr('string')

  attachable: ((key, value) ->
    if arguments.length == 2 && value
      property = typeMap.get value.constructor.toString()
      @set property, value
    else
      @get('discussion') || @get('deal')
  ).property()
