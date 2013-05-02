Ember.Handlebars.registerBoundHelper 'contactSourceImage', (source, options) ->
  # FIXME: determine image src from status
  url = "http://placehold.it/16x16"

  new Handlebars.SafeString("<img src='#{url}' class='#{options.hash.class}'/>")
