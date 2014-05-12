Radium.Comment = Radium.Model.extend Radium.AttachmentsMixin,
  Radium.TimestampsMixin,
  user: DS.belongsTo('Radium.User')

  text: DS.attr('string')

  commentable: Ember.computed('email', 'discussion', 'deal', 'meeting', 'todo', 'call', 'activity', 'note', (key, value) ->
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
      @get('activity') ||
      @get('note')
  )

  activity: DS.belongsTo('Radium.Activity')
  call: DS.belongsTo('Radium.Call')
  email: DS.belongsTo('Radium.Email')
  deal: DS.belongsTo('Radium.Deal')
  discussion: DS.belongsTo('Radium.Discussion')
  meeting: DS.belongsTo('Radium.Meeting')
  todo: DS.belongsTo('Radium.Todo')
  note: DS.belongsTo('Radium.Note')
  attachedFiles: DS.attr('array')
