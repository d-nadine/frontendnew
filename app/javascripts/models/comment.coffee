Radium.Comment = Radium.Model.extend Radium.AttachmentsMixin,
  Radium.TimestampsMixin,
  user: DS.belongsTo('Radium.User')

  text: DS.attr('string')

  commentable: Ember.computed('email', 'deal', 'meeting', 'todo', 'activity', 'note', (key, value) ->
    if arguments.length == 2 && value
      property = value.constructor.toString().split('.')[1].toLowerCase()
      @set property, value
    else
      @get('email') ||
      @get('discussion') ||
      @get('deal') ||
      @get('meeting') ||
      @get('todo') ||
      @get('activity') ||
      @get('note')
  )

  activity: DS.belongsTo('Radium.Activity')
  email: DS.belongsTo('Radium.Email')
  deal: DS.belongsTo('Radium.Deal')
  meeting: DS.belongsTo('Radium.Meeting')
  todo: DS.belongsTo('Radium.Todo')
  note: DS.belongsTo('Radium.Note')
  attachedFiles: DS.attr('array')
