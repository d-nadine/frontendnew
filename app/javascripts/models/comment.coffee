Radium.Comment = Radium.Model.extend Radium.AttachmentsMixin,
  user: DS.belongsTo('Radium.User')

  text: DS.attr('string')

  commentable: ((key, value) ->
    if arguments.length == 2 && value
      property = value.constructor.toString().split('.')[1].toLowerCase()
      @set property, value
    else
      @get('email') ||
        @get('discussion') ||
        @get('deal') ||
        @get('meeting') ||
        @get('todo') ||
        @get('call') ||
        @get('activity')
  ).property('email', 'discussion', 'deal', 'meeting', 'todo', 'call', 'activity')
  activity: DS.belongsTo('Radium.Activity')
  email: DS.belongsTo('Radium.Email')
  deal: DS.belongsTo('Radium.Deal')
  discussion: DS.belongsTo('Radium.Discussion')
  meeting: DS.belongsTo('Radium.Meeting')
  todo: DS.belongsTo('Radium.Todo')
