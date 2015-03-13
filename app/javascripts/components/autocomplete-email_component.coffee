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

  focusOut: (e) ->
    @_super.apply this, arguments

    val = @autocompleteElement().val()

    return if !val || !Radium.EMAIL_REGEX.test val

    @sendAction 'queryProfile', val
