Radium.AutocompleteEmailComponent = Ember.TextField.extend Radium.KeyConstantsMixin,
  Radium.AutocompleteMixin,
  actions:
    setBindingValue: (object) ->
      @sendAction 'action', object.get('person')

  autocompleteElement: ->
    @$()

  input: (e) ->
    el = @autocompleteElement()

    @set 'query', el.val()

  type: 'email'
