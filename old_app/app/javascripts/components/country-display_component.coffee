Radium.CountryDisplayComponent = Ember.Component.extend
  classNameBindings: [":selectbox-option"]
  tagName: "span"

  countryList: Ember.computed.oneWay 'targetObject.countryList'

  icon: Ember.computed 'country.flag', 'countryList.[]', ->
    unless country = @get('country')
      country = @get('defaultCountry')

    if typeof(country) == "string"
      country = @countryFromString(country) || country

    return unless country?.key

    key = country.key.substr(0, 2)
    "bfh-flag-#{key}"

  displayName: Ember.computed 'country', ->
    unless country = @get('country')
      return @get('defaultCountry.label')

    if typeof(country) == "string"
      country = @countryFromString(country) || country

    if country.label
      country.label
    else
      country

  defaultCountry: Ember.computed 'countryList.[]', ->
    @countryFromString "US"

  countryFromString: (key) ->
    Radium.Countries.find (c) -> c.key.toLowerCase() == key.toLowerCase()
