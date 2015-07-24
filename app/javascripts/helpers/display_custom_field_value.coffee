Ember.Handlebars.registerBoundHelper 'displayCustomFieldValue', (customFieldValue, options) ->
  value = customFieldValue?.get('value') || ''

  return unless value.length

  parseDate = ->
    date = Ember.DateTime.parse(value)

    if date
      date.toHumanFormat()
    else
      "Invalid Date"

  result = switch customFieldValue.get('field.type')
             when "text" then value.replace(/\n/g, "<br>")
             when "url" then "<a href='#{value}' target='_blank'>#{value}</a>"
             when "date" then parseDate()
             when "currency" then accounting.formatMoney(value)

  return new Handlebars.SafeString(result)
