Ember.Handlebars.registerHelper 'linkToPerson', (name) ->
  args = [].slice.apply arguments

  args[1].contexts.push this
  args[1].types.push "ID"

  name = if this.constructor == Radium.User
          "user"
         else if this.constructor == Radium.Contact
           "contact"
        else
          throw new Error("#{this.constructor} is unknown type for linkToPerson")

  args.unshift name

  Ember.Handlebars.helpers.linkTo.apply this, args
