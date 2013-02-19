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
      property = value.constructor.toString().split('.')[1].toLowerCase()
      @set property, value
    else
      @get('email') || @get('discussion') || @get('deal') || @get('meeting') || @get('todo')
  ).property('email', 'discussion', 'deal', 'meeting', 'todo')

