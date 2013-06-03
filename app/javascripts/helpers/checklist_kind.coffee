Ember.Handlebars.registerBoundHelper 'checklistKind', (kind, options) ->
  style = options.hash.style || options.hash.size || 'small'

  icon = if kind == 'meeting'
           "icon-calendar"
         else
           "icon-#{kind}"

  new Handlebars.SafeString("<i class='#{icon}'></i>")
