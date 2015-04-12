Ember.Handlebars.registerBoundHelper 'displayCustomFieldValue', (customFieldValue, options) ->
  value = customFieldValue.get('value') || ''

  return unless value.length

  result = switch customFieldValue.get('field.type')
             when "text" then value.replace(/\n/g, "<br>")
             when "url" then value
             when "date" then Ember.DateTime.parse(value).toHumanFormat()
             when "currency" then accounting.formatMoney(value)

  return new Handlebars.SafeString(result)
