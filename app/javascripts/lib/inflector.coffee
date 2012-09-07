Radium.Inflector = Em.Object.create
  pluralize: (str) ->
    "#{str}s"

  singularize: (str) ->
    str.replace(/s$/, '')

  capitalize: (str) ->
    str.replace(/^([a-z])/, (match) -> match.toUpperCase() )

  humanize: (lowerCaseAndUnderscoredWord) ->
    result = lowerCaseAndUnderscoredWord.toString()
    result = result.replace(/_id$/, "").
                    replace(/_/g, ' ').
                    replace /([a-z\d]*)/gi, (match) ->
                      match.toLowerCase()

String.prototype.pluralize = ->
  Radium.Inflector.pluralize(this)

String.prototype.singularize = ->
  Radium.Inflector.singularize(this)

String.prototype.humanize = ->
  Radium.Inflector.humanize(this)

String.prototype.capitalize = ->
  Radium.Inflector.capitalize(this)
