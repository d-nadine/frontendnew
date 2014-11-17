# https://github.com/radiumsoftware/frontend/blob/2d3eb185e0b18f35b9449836cb3a7bf4f35c23c9/app/templates/people/index.hbs
# http://jsbin.com/fitale/5/edit
Ember.Handlebars.registerBoundHelper 'getProperty', (context, property, options) ->
  prop = context.get(property.binding)

  if Ember.isEmpty prop
    return ""

  unless  property.hasOwnProperty "route"
    return new Handlebars.SafeString("<span>#{prop}</span>")

  args = Array::slice.call(arguments, 2)

  options.types = ["ID", "STRING", "ID"]
  options.contexts = [context, context, context]

  args.unshift "id"
  args.unshift property.route
  args.unshift property.binding

  Ember.Handlebars.helpers["link-to"].apply context, args