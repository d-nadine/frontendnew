# FIXME: this can be replace with the component helper when we upgrade to 1.11.0
Ember.Handlebars.registerHelper 'renderComponent', (contextPath, propertyPath, options) ->
  context = Ember.Handlebars.get(this, contextPath, options)
  property = Ember.Handlebars.get(this, propertyPath, options)
  helper = Ember.Handlebars.resolveHelper(options.data.view.container, property.component)

  options.contexts = []
  options.types = []

  property.bindings.forEach (binding) ->
    options.hash[binding.name] = binding.value
    options.hashTypes[binding.name] = if binding.static then "STRING" else "ID"
    options.hashContexts[binding.name] = context

  actions = property.actions || []

  actions.forEach (action) =>
    options.hash[action.name] = (action.value)
    options.hashTypes[action.name] = "STRING"
    options.hashContexts[action.name] = this

  helper.call(context, options)