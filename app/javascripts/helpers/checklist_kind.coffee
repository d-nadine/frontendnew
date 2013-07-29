Ember.Handlebars.registerBoundHelper 'checklistKind', (kind, options) ->
  style = options.hash.style || options.hash.size || 'small'

  icon = if kind == 'meeting'
           "ss-standard ss-calendar"
         else
           "ss-#{kind}"

  new Handlebars.SafeString("<i class='#{icon}'></i>")
