Ember.Handlebars.registerBoundHelper 'currency', (value, options) ->
  accounting.formatMoney(value)