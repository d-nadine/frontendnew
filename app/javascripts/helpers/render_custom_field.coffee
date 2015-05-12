# FIXME: this can be replace with the component helper when we upgrade to 1.11.0
Ember.Handlebars.registerHelper 'renderCustomField', (customFieldPath, resourcePath, options) ->
  customField = Ember.Handlebars.get(this, customFieldPath, options)
  resource = Ember.Handlebars.get(this, resourcePath, options)

  component = "customfield-#{customField.get('type')}input"

  helper = Ember.Handlebars.resolveHelper(options.data.view.container, component)

  options.contexts = []
  options.types = []

  customFieldMap = resource.get('customFieldMap')

  Ember.assert("the resource must have a customFieldMap", customFieldMap)

  field = customFieldMap.get(customField)

  options.hash['customFieldValue'] = field
  options.hash['currencySymbol'] = @get('targetObject.currencySymbol')

  helper.call this, options
