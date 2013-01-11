Radium.Contact = Radium.Person.extend Radium.FollowableMixin,
  status: DS.attr("string")

  displayName: (->
    @get('name') || @get('email') || @get('phoneNumber')
  ).property('name', 'email', 'phoneNumber')
