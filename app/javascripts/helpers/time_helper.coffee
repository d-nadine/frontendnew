###
Formats a variety of date formats into the standard 12-hour clock
time format.

@param {Date|Ember.DateTime|String} property
Can format either a native JS Date, Ember.DateTime instance or a ISO8601-
formatted string.
@param {Hash} options
@return {String} A time string eg: '8:31 AM'
###
Handlebars.registerHelper "formatTime", (property, options) ->
  dateParams = undefined
  view = options.data.view
  context = (options.context and options.context[0]) or this
  value = Ember.get(this, property)
  parseDate = (value) ->
    date = undefined
    type = Ember.typeOf(value)
    if type is "date"
      dateParams = value.getTime()
      date = Ember.DateTime.create(dateParams)
    date = value  if type is "instance"
    date = Ember.DateTime.create(new Date(value).getTime())  if type is "string"
    date.toFormattedString "%i:%M %p"

  # Observer function, rerenders the view with the updated date.
  observer = ->
    elem = view.$()

    # Delete the observes if the view gets got.
    if !elem || elem.length is 0
      Ember.removeObserver context, property, invoker
      return
    newValue = Ember.get(context, property)

    # type = Ember.typeOf(newValue),
    updatedDate = parseDate(newValue)
    # FIXME NOT_FOUND_ERR: DOM Exception 8 
    # view.$().text updatedDate
    # view.rerender()

  invoker = ->
    Ember.run.once observer

  Ember.addObserver context, property, invoker
  parseDate value

