Ember.Handlebars.registerHelper 'ifIsLive', (property, options) ->
  model = this.get(property)

  unless this.hasOwnProperty 'isLive'
    Ember.defineProperty this, 'isLive', Ember.computed 'isNew', 'isDeleted', 'isLoading', =>
      not model.get('isNew') && not model.get('isDeleted') && not model.get('isLoading')

  Ember.Handlebars.helpers.boundIf.call this, "isLive", options
