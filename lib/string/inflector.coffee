String::pluralize = ->
    return "companies" if this.toString() == 'company'
    "#{@}s"

String::singularize = ->
  map = {
    Companies: "company",
    emailAddresses: "Email Address"
    phoneNumbers: "Phone Number"
  }

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
  /^(?=.*[0-9])\d{1,15}(\.\d{1,2})?$/.test accounting.unformat(this)

String::dedasherize = ->
  @replace(/[-]/g, ' ')

String::reformatHtml = ->
  @replace(/<p[^>]*>/g, '').replace(/<\/p>/g, '\n\n')
  .replace(/\<div\>\<br\>\<\/div\>/i, '\n')
  .replace(/<br\s*\/?>/ig,"\n")
  .replace(/&nbsp;/g,' ')
  .replace(/(<([^>]+)>)/ig,"");
