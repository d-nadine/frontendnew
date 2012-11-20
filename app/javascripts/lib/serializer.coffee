Radium.Serializer = DS.RESTSerializer.extend
  init: ->
    @_super.apply(this, arguments)
    for name, transform of Radium.transforms
      @registerTransform name, transform

