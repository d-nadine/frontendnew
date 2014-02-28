Radium.typeToLinks =
  email: 'emails.show'
  meeting: 'calendar.task'
  todo: 'calendar.task'

Ember.Handlebars.registerHelper "resource-link-to", (path, options) ->
  args = Array::slice.call(arguments, 1)
  resource = if path.length
                @get(path)
             else if this instanceof Em.ObjectController
               @get('model')
             else if this instanceof Radium.Model
               this

  return '' unless resource

  if resource.constructor is Radium.Attachments
    return new Handlebars.SafeString "<a href='#{resource.get('url')}' target='_blank'>#{resource.get('fileName')}</a>"

  return unless resource.humanize

  resourceRoute = resource.humanize()

  if Radium.typeToLinks[resourceRoute]
    resourceRoute = Radium.typeToLinks[resourceRoute]

  unless options.fn
    options.types = ["ID", "STRING", "ID"]
    options.contexts = [this, this, this]
    args.unshift path

    if resource.constructor is Radium.Email
      folder = if Ember.ControllerMixin.detect(this) && @container.lookup('controller:currentUser').get('model') == this.get("sender")
                "sent"
               else
                 "inbox"

      options.contexts.push this
      options.types.insertAt(1, "STRING")
      args.unshift folder

    args.unshift resourceRoute
    prop = if path.length then ".displayName" else "displayName"
    args.unshift path + prop

  else
    options.types = ["STRING", "ID"]
    options.contexts = [this, this]
    args.unshift path
    args.unshift resourceRoute

  Ember.Handlebars.helpers["link-to"].apply this, args
