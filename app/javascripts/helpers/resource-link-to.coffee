#http://jsbin.com/OnuCaCep/38/edit
Radium.typeToLinks =
  email: 'emails.show'
  meeting: 'calendar.task'
  todo: 'calendar.task'

Ember.Handlebars.registerHelper "resource-link-to", (name, options) ->
  args = Array::slice.call(arguments, 1)
  resource = @get(name)

  if resource.constructor is Radium.Attachments
    return new Handlebars.SafeString "<a href='#{resource.get('url')}' target='_blank'>#{resource.get('fileName')}</a>"

  resourceRoute = resource.humanize()

  if Radium.typeToLinks[resourceRoute]
    resourceRoute = Radium.typeToLinks[resourceRoute]

  unless options.fn
    options.types = ["STRING", "STRING", "ID"]
    options.contexts = [this, this, this]
    args.unshift name
    args.unshift resourceRoute
    args.unshift resource.get("displayName")
  else
    options.types = ["STRING", "ID"]
    options.contexts = [this, this]
    args.unshift name
    args.unshift resourceRoute

  unless resource.get('isLoaded')
    observer = =>
      if resource.get('isLoaded')
        # how do I get the LinkView to rerender here?
        resource.removeObserver 'isLoaded', observer

    resource.addObserver 'isLoaded', observer

  Ember.Handlebars.helpers["link-to"].apply this, args
