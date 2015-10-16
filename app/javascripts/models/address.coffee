Radium.Address = Radium.Model.extend
  name: DS.attr('string')
  isPrimary: DS.attr('boolean')
  street: DS.attr('string')
  line2: DS.attr('string')
  state: DS.attr('string')
  city: DS.attr('string')
  country: DS.attr('string')
  zipcode: DS.attr('string')

  formatted: Ember.computed 'street', 'state', 'city', 'country', 'zipcode', ->
    [@get('state'), @get('city'), @get('zipcode')].join(' ')

  value: Ember.computed 'isNew', 'street', 'line2', 'state', 'city', 'country', 'zipcode', ->
    return if @get('isNew')

    !Ember.isEmpty(@get('street')) ||!Ember.isEmpty(@get('line2')) || !Ember.isEmpty(@get('state')) || !Ember.isEmpty(@get('city')) || !Ember.isEmpty(@get('zipcode'))

  getAddressHash: ->
    isPrimary: @get('isPrimary')
    name: @get('name')
    street: @get('street')
    line2: @get('line2')
    city: @get('city')
    state: @get('state')
    zipcode: @get('zipcode')
    country: @get('country') || "US"
    isCurrent: @get('isPrimary')

  toString:  ->
    parts = [
      @get('street')
      @get('state')
      @get('line2')
      @get('city')
      @get('country')
      @get('zipcode')
    ].compact()

    if parts.length
      parts.join ' '
    else
      ""
