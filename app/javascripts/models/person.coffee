###
The base model class for any model that has a name, id, created_at and updated_at key
@returns {Object}
###
Radium.Person = Radium.Core.extend
  name: DS.attr('string')

  # Computed name properties
  abbrName: (->
    if @get('name')
      nameArray = @get('name').split(' ')
      if nameArray.length > 1
        nameArray[0] + ' ' + nameArray[nameArray.length - 1].substr(0, 1) + '.'
      else
        nameArray[0]
  ).property('name')
  firstName: (->
    @get('name').split(' ')[0]
  ).property('name')
  avatar: DS.attr('object')

  # Default hasMany groups
  deals: DS.hasMany('Radium.Deal')
  campaigns: DS.hasMany('Radium.Campaign')
  todos: DS.hasMany('Radium.Todo')
  meetings: DS.hasMany('Radium.Meeting')
  reminders: DS.hasMany('Radium.Reminder')
  groups: DS.hasMany('Radium.Group')
  notes: DS.hasMany('Radium.Note')
  phoneCalls: DS.hasMany('Radium.PhoneCall')
  messages: DS.hasMany('Radium.Message')
  activities: DS.hasMany('Radium.Activity')
  comments: DS.hasMany('Radium.Comment')
