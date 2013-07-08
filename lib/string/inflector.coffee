String::pluralize = ->
    "#{@}s"

String::singularize = ->
  @replace /s$/, ''

String::capitalize = ->
  @replace(/^([a-z])/, (match) -> match.toUpperCase() )

String::humanize = ->
  str = @replace(/_id$/, "").
    replace(/_/g, ' ').
    replace /([a-z\d]*)/gi, (match) -> match.toLowerCase()

  str = str.split('.').pop()

