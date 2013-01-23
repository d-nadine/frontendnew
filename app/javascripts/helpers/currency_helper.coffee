#FIXME: use registerBoundHelper after upgraded
Ember.Handlebars.registerHelper 'currency', (property, options) ->
  value = Ember.get(this, property)
  return if !value

  value = parseFloat(value).toFixed(2)

  "$" + value.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,")
