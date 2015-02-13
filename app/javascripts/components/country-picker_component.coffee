Radium.CountryPickerComponent = Ember.Component.extend
  actions:
    changeCountry: (country) ->
      @sendAction "changeCountry", country

  classNameBindings: [":country-picker"]
