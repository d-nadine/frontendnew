typeMap = Ember.Map.create()

typeMap.set 'Radium.Deal', 'deal'
typeMap.set 'Radium.Contact', 'deal'

Radium.Discussion = Radium.Model.extend Radium.CommentsMixin,
  Radium.AttachmentsMixin,

  user: DS.belongsTo('Radium.User')
  deal: DS.belongsTo('Radium.Deal', inverse: 'discussions')
  contact: DS.belongsTo('Radium.Contact', inverse: 'discussions')

  topic: DS.attr('string')

  reference: ((key, value) ->
    if arguments.length == 2 && value
      property = typeMap.get value.constructor.toString()
      @set property, value
    else
      @get('deal') || @get('contact')
  ).property('deal', 'contact')
