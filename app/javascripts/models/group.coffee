Radium.Group = Radium.Model.extend Radium.FollowableMixin,
  name: DS.attr('string')
  street: DS.attr('string')
  state: DS.attr('string')
  city: DS.attr('string')
  country: DS.attr('string')
  zipcode: DS.attr('string')

  address: ( ->
    [
      @get('street')
      @get('state')
      @get('city')
      @get('country')
      @get('zipcode')
    ].filter( (part) -> part).join(' ')

  ).property('street', 'state', 'city', 'country', 'zipcode')
