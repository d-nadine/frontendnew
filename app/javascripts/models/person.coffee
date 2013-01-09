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

  isContact: (->
    this.constructor == Radium.Contact
  ).property()
  # Default hasMany groups
  reminders: DS.hasMany('Radium.Reminder')
  comments: DS.hasMany('Radium.Comment')
