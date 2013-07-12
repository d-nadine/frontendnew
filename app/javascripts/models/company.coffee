Radium.Company = Radium.Model.extend Radium.HasTasksMixin,
  contacts: DS.hasMany('Radium.Contact')
  addresses: DS.hasMany('Radium.Address')
  activities: DS.hasMany('Radium.Activity', inverse: 'companies')

  tags: DS.hasMany('Radium.Tag')
  tagNames: DS.hasMany('Radium.TagName')
  addresses: DS.hasMany('Radium.Address')

  primaryContact: DS.belongsTo('Radium.Contact', inverse: null)
  user: DS.belongsTo('Radium.User')

  name: DS.attr('string')
  website: DS.attr('string')
  notes: DS.attr('string')
  status: DS.attr('string')

  primaryAddress: Radium.computed.primary 'addresses'

  todos: DS.hasMany('Radium.Todo')
  calls: DS.hasMany('Radium.Call')
  meetings: DS.hasMany('Radium.Meeting')
  tasks: Radium.computed.tasks('todos', 'calls', 'meetings')
