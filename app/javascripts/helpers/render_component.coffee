Ember.Handlebars.registerHelper 'renderComponent', (contextPath, propertyPath, options) ->
  context = Ember.Handlebars.get(this, contextPath, options)
  property = Ember.Handlebars.get(this, propertyPath, options)
  helper = Ember.Handlebars.resolveHelper(options.data.view.container, property.component)

  options.contexts = []
  options.types = []

  property.bindings.forEach (binding) ->
    options.hash[binding] = binding
    options.hashTypes[binding] = "ID"
    options.hashContexts[binding] = context

  helper.call(context, options)