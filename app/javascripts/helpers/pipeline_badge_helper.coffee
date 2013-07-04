Ember.Handlebars.registerBoundHelper 'pipelineBadge', (group, options) ->
  return if group == undefined

  style = if group == "closed"
            "success"
          else if group =="lost"
            "important"
          else
            "warning"

  args = Array.prototype.slice.call(arguments, 1)
  args.unshift 'length'
  args[1].hash.style = style

  Ember.Handlebars.helpers.badge.apply this, args
