Ember.Handlebars.registerBoundHelper 'social-icon', (value, options) ->
  dt = if value.get('type') == "facebook"
            "<dt><i class='ss-icon ss-social ss-facebook muted'></i></dt>"
          else if value.get('type') == "twitter"
            "<dt><i class='ss-icon ss-social ss-twitter muted'></i></dt>"
          else
            "<dt><i class='ss-symbolicons-block ss-share muted'></i></dt>"

  new Handlebars.SafeString dt
