formats =
  long: "toHumanFormatWithTime"
  brief: "toBriefFormat"

Ember.Handlebars.registerBoundHelper 'emailSentAt', (value, options) ->
  Ember.assert "null value passed to eamailSentAt helper", value

  unless value
    value = @get('updatedAt')

  options.hash.format ||= 'brief'
  format = formats[options.hash.format]

  now = Ember.DateTime.create()

  days = value.daysApart now

  text = if days < 1
            value.toMeridianTime()
         else
            value[format]()

  new Handlebars.SafeString "<time>#{text}</time>"
