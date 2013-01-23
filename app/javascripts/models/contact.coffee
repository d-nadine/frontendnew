Radium.Contact = Radium.Person.extend Radium.FollowableMixin,
  status: DS.attr("string")
  user: DS.belongsTo('Radium.User')

  displayName: (->
    @get('name') || @get('email') || @get('phoneNumber')
  ).property('name', 'email', 'phoneNumber')

  daysSinceCreation: ( ->
    today = Ember.DateTime.create()
    createdAt = @get('createdAt')

    Ember.DateTime.differenceInDays(today, createdAt)
  ).property('created_at')

  daysSinceText: ( ->
    daysSinceCreation = @get('daysSinceCreation')

    if daysSinceCreation <= 1
      return "1 day"

    "#{daysSinceCreation} days"
  ).property('daysSinceCreation')
