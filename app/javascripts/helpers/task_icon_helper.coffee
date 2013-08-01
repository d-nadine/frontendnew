Ember.Handlebars.registerBoundHelper 'taskIcon', (task, options) ->
  cssClass = if task.constructor is Radium.Todo
               "ss-check"
             else if task.constructor is Radium.Call
               "ss-phone"
             else if task.constructor is Radium.Meeting
               "ss-calendar"

  Ember.assert "Unknown task type passed to taskIcon helper", cssClass

  new Handlebars.SafeString "<i class='ss-standard #{cssClass}'></i>"
