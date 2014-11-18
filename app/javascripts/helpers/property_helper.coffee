# https://github.com/radiumsoftware/frontend/blob/2d3eb185e0b18f35b9449836cb3a7bf4f35c23c9/app/templates/people/index.hbs
Ember.Handlebars.registerBoundHelper 'getProperty', (context, property, options) ->
  defaults =
    className: ""
    context: "this"
    avatar: false

  property = Ember.merge defaults, property

  prop = context.get(property.binding)

  if Ember.isEmpty prop
    return ""

  unless  property.hasOwnProperty "route"
    return new Handlebars.SafeString("<span>#{prop}</span>")

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
    args.unshift context.get(property.context).humanize().pluralize()

  args.unshift property.route
  args.unshift property.binding

  Ember.Handlebars.helpers["link-to"].apply context, args