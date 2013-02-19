typeMap = Ember.Map.create()

typeMap.set 'Radium.Email', 'email'
typeMap.set 'Radium.Deal', 'deal'
typeMap.set 'Radium.Discussion', 'discussion'
typeMap.set 'Radium.Meeting', 'meeting'
typeMap.set 'Radium.Todo', 'todo'

Radium.Comment = Radium.Model.extend Radium.AttachmentsMixin,
  email: DS.belongsTo('Radium.Email', inverse: 'comments')
  discussion: DS.belongsTo('Radium.Discussion', inverse: 'comments')
  deal: DS.belongsTo('Radium.Deal', inverse: 'comments')
  meeting: DS.belongsTo('Radium.Meeting', inverse: 'comments')
  todo: DS.belongsTo('Radium.Todo', inverse: 'comments')

  user: DS.belongsTo('Radium.User', inverse: 'comments')

  text: DS.attr('string')

  commentable: ((key, value) ->
    if arguments.length == 2 && value
      property = typeMap.get value.constructor.toString()
      @set property, value
    else
      @get('email') || @get('discussion') || @get('deal') || @get('meeting') || @get('todo')
  ).property('email', 'discussion', 'deal', 'meeting', 'todo')

