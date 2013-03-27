Ember.Handlebars.registerBoundHelper 'currency', (value, options) ->
  return if !value

  value = parseFloat(value).toFixed(2)

  "$" + value.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,")
