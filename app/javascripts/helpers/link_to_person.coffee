Ember.Handlebars.registerHelper 'linkToPerson', (objectPath) ->
  object = Ember.Handlebars.get this, objectPath

  args = [].slice.apply arguments

  args[1].contexts.push this
  args[1].types.push "ID"

  route = if object.constructor == Radium.User
          "user"
         else if object.constructor == Radium.Contact
           "contact"
         else
           throw new Error("#{object.constructor} is unknown type for linkToPerson")

  args.unshift route

  Ember.Handlebars.helpers.linkTo.apply this, args
