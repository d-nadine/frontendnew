Ember.Handlebars.registerBoundHelper 'dynamicAvatar', (context, property, options) ->
  args = Array::slice.call(arguments, 2)

  context = if property.hasOwnProperty "context"
              item.get(property.context)
            else
              context

  args.unshift context
  options.types = [context]

  options.hash.style = "tiny"

  Ember.Handlebars.helpers.avatar.apply context, args