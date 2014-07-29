Radium.Followee = Radium.Model.extend
  follower: DS.belongsTo("Radium.User", inverse: 'following')

  followable: Ember.computed('user', 'contact', (key, value) ->
    if arguments.length == 2 && value
      property = value.humanize()
      @set property, value
    else
      @get('contact') || @get('user')
  )

  user: DS.belongsTo("Radium.User")
  contact: DS.belongsTo("Radium.Contact")
