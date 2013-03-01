Radium.Address = Radium.Model.extend
  street: DS.attr('string')
  state: DS.attr('string')
  city: DS.attr('string')
  country: DS.attr('string')
  zipcode: DS.attr('string')

  toString:  ->
    parts = [
      @get('street')
      @get('state')
      @get('city')
      @get('country')
      @get('zipcode')
    ].filter( (part) -> part)

    if parts.length
      parts.join ' '
    else
      ""
