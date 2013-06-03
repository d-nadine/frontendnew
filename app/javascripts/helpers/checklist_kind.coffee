Ember.Handlebars.registerBoundHelper 'checklistKind', (kind, options) ->
  style = options.hash.style || options.hash.size || 'small'

  icon = if kind == 'meeting'
           "icon-calendar"
         else
           "icon-#{kind}"

  if kind == 'deal'
    new Handlebars.SafeString('<img src="http://placehold.it/14x14" alt="">')
  else
    new Handlebars.SafeString("<i class='#{icon}'></i>")
