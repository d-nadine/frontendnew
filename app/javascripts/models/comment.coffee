Radium.Comment = Radium.Model.extend Radium.AttachmentsMixin,
  email: DS.belongsTo('Radium.Email')
  discussion: DS.belongsTo('Radium.Discussion')
  deal: DS.belongsTo('Radium.Deal')
  meeting: DS.belongsTo('Radium.Meeting')
  todo: DS.belongsTo('Radium.Todo')

  user: DS.belongsTo('Radium.User')

  text: DS.attr('string')

  commentable: ((key, value) ->
    if arguments.length == 2 && value
      property = value.constructor.toString().split('.')[1].toLowerCase()
      @set property, value
    else
      @get('email') || @get('discussion') || @get('deal') || @get('meeting') || @get('todo')
  ).property('email', 'discussion', 'deal', 'meeting', 'todo')

