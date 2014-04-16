String::pluralize = ->
    return "companies" if this.toString() == 'company'
    "#{@}s"

String::singularize = ->
  map = {Companies: "company"}

  if ret = map[this]
    ret
  else
    @replace /s$/, ''

String::capitalize = ->
  @replace(/^([a-z])/, (match) -> match.toUpperCase() )

String::humanize = ->
  str = @replace(/_id$/, "").
    replace(/_/g, ' ').
    replace /([a-z\d]*)/gi, (match) -> match.toLowerCase()

  str = str.split('.').pop()

String::constantize = ->
  Ember.get Radium, @singularize().classify()

String::isCurrency = ->
  /^(?=.*[0-9])\d{1,15}(\.\d{1,2})?$/.test this
