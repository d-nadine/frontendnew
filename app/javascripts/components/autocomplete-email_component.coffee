Radium.AutocompleteEmailComponent = Ember.TextField.extend Radium.KeyConstantsMixin,
  Radium.AutocompleteMixin,
  autocompleteElement: ->
    @$()
