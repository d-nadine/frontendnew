Radium.Address = Radium.Model.extend
  name: DS.attr('string')
  isPrimary: DS.attr('boolean')
  street: DS.attr('string')
  state: DS.attr('string')
  city: DS.attr('string')
  country: DS.attr('string')
  zipcode: DS.attr('string')

  formatted: ( ->
    [@get('state'), @get('city'), @get('zipcode')].join(', ')
  ).property('street', 'state', 'city', 'country', 'zipcode')

  value: ( ->
    return if @get('isNew')

    !Ember.isEmpty(@get('street')) || !Ember.isEmpty(@get('state')) || !Ember.isEmpty(@get('city')) || !Ember.isEmpty(@get('zipcode'))
  ).property('isNew', 'street', 'state', 'city', 'country', 'zipcode')

  getAddressHash: ->
    isPrimary: this.get('isPrimary')
    name: this.get('name')
    street: this.get('street')
    city: this.get('city')
    state: this.get('state')
    zipcode: this.get('zipcode')
    country: this.get('country')

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
