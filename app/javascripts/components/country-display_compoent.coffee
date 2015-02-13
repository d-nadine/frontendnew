Radium.CountryDisplayComponent = Ember.Component.extend
  classNameBindings: [":selectbox-option"]
  tagName: "span"
  icon: Ember.computed 'country.flag', ->
    unless country = @get('country')
      return

    key = country.key.substr(0, 2)
    "bfh-flag-#{key}"
