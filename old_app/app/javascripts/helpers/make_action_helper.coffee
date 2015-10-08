Ember.Handlebars.registerBoundHelper 'makeAction', ->
  context = arguments[0]
  args = Array::slice.call(arguments, 1, -1)
  ->
    context.send.apply context, args