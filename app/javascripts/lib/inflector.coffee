Radium.Inflector = Em.Object.create
  pluralize: (str) ->
    "#{str}s"

  singularize: (str) ->
    str.replace(/s$/, '')


String.prototype.pluralize = ->
  Radium.Inflector.pluralize(this)

String.prototype.singularize = ->
  Radium.Inflector.singularize(this)
