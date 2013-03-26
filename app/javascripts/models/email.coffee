require 'lib/radium/task_list'

Radium.Email = DS.Model.extend Radium.CommentsMixin,
  Radium.AttachmentsMixin,

  todos: DS.hasMany('Radium.Todo')
  meetings: DS.hasMany('Radium.Meeting')

  subject: DS.attr('string')
  message: DS.attr('string')
  read: DS.attr('boolean')
  isTracked: DS.attr('boolean')
  sentAt: DS.attr('datetime')

  sender: DS.attr('object')

  # FIXME: find a better way to handle this
  # once we get the API connntected
  cc: DS.attr('array')
  bcc: DS.attr('array')

  tasks: Radium.computed.tasks('todos', 'meetings')
