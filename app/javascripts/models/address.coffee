Radium.Address = Radium.Model.extend
  name: DS.attr('string')
  isPrimary: DS.attr('boolean')
  street: DS.attr('string')
  state: DS.attr('string')
  city: DS.attr('string')
  country: DS.attr('string')
  zipcode: DS.attr('string')
  email: DS.attr('string')
  phone: DS.attr('string')

  formatted: Ember.computed 'street', 'state', 'city', 'country', 'zipcode', ->
    [@get('state'), @get('city'), @get('zipcode')].join(' ')

  value: Ember.computed 'isNew', 'street', 'state', 'city', 'country', 'zipcode', 'email', 'phone', ->
    return if @get('isNew')

    !Ember.isEmpty(@get('street')) || !Ember.isEmpty(@get('state')) || !Ember.isEmpty(@get('city')) || !Ember.isEmpty(@get('zipcode')) || !Ember.isEmpty(@get('email')) || !Ember.isEmpty(@get('phone'))

  getAddressHash: ->
    isPrimary: @get('isPrimary')
    name: @get('name')
    email: @get('email')
    phone: @get('phone')
    street: @get('street')
    city: @get('city')
    state: @get('state')
    zipcode: @get('zipcode')
    country: @get('country') || "US"
    isCurrent: @get('isPrimary')

  toString:  ->
    parts = [
      @get('email')
      @get('phone')
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
