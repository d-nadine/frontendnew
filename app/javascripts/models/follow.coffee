Radium.Follow = Radium.Model.extend
  follower: DS.belongsTo('Radium.User')

  followable: Ember.computed('contact', 'user', (key, value) ->
    if arguments.length == 2 && value
      @set value.humanize(), value
    else
      @get('contact') || @get('user')
  )

  contact: DS.belongsTo('Radium.Contact')
  user: DS.belongsTo('Radium.User')
