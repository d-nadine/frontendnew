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
  company: DS.belongsTo('Radium.Company')

  name: Ember.computed 'user', 'contact', ->
    followable = @get('user') || @get('contact') || @get('company')
    followable.get('displayName')

  successMessage: Ember.computed 'followable', 'followable.displayName', ->
    "You are now following #{@get('name')}"

  errorMessage: Ember.computed 'followable.displayName', ->
    "An error has occurred and you cannot follow #{@get('name')}"

Radium.Unfollow = Radium.Follow.extend
  successMessage: Ember.computed 'followable.displayName', ->
    "You are no longer following #{@get('name')}"

  errorMessage: Ember.computed 'followable.displayName', ->
    "An error has occurred and you cannot unfollow #{@get('name')}"
