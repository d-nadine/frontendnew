Radium.RegexInputComponent = Ember.TextField.extend Radium.KeyConstantsMixin,
  input: (e) ->
    @_super.apply this, arguments

    Ember.assert "You mst specify a regex to validate against", @regex

    el = @$()

    reset = ->
      el.css 'border', '1px solid #cccccc'

    unless el.val().length
      return reset()

    unless @regex.test el.val()
      el.css 'border', '1px solid red'
    else
      reset()
