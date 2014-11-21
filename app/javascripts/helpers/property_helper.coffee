Ember.Handlebars.registerBoundHelper 'getProperty', (context, property, options) ->
  defaults =
    className: ""
    context: "this"
    avatar: false

  property = Ember.merge defaults, property

  prop = context.get(property.binding)

  unless  property.hasOwnProperty "route"
    options.contexts = [context]
    options.types = ["ID"]

    return Ember.Handlebars.helpers.bind.call(context, property.binding, options)

  args = Array::slice.call(arguments, 2)

  options.types = ["ID", "STRING", "ID"]
  options.contexts = [context, context, context]

  id = if property.context
          "#{property.context}.id"
       else
         "id"

  args.unshift id

  if property.route == "calendar.task"
    options.contexts.push context
    options.types.insertAt(1, "STRING")
    return unless context.get(property.context)
    args.unshift context.get(property.context).humanize().pluralize()

  args.unshift property.route
  args.unshift property.binding

  Ember.Handlebars.helpers["link-to"].apply context, args