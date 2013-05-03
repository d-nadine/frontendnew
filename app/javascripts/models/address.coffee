Radium.Address = Radium.Model.extend
  name: DS.attr('string')
  isPrimary: DS.attr('boolean')
  street: DS.attr('string')
  state: DS.attr('string')
  city: DS.attr('string')
  country: DS.attr('string')
  zipcode: DS.attr('string')

  value: ( ->
    return if @get('isNew')

    !Ember.isEmpty(@get('street')) || !Ember.isEmpty(@get('state')) || !Ember.isEmpty(@get('city')) || !Ember.isEmpty(@get('zipcode'))
  ).property('isNew', 'street', 'state', 'city', 'country', 'zipcode')

  toString:  ->
    parts = [
      @get('street')
      @get('state')
      @get('city')
      @get('country')
      @get('zipcode')
    ].compact()

    if parts.length
      parts.join ' '
    else
      ""
