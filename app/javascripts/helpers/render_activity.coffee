Ember.Handlebars.registerBoundHelper 'renderActivity', (activity, options) ->
  supressNotes = (this instanceof Radium.RenderActivityComponent) && @get('tag') == "note"

  if supressNotes
    template = "activities/note_link"
    options.contexts[0] = @get('targetObject')
  else
    template = "activities/#{@get('tag')}"

  options.contexts[1] = options.contexts[0]

  options.types[0] = "STRING"
  Ember.Handlebars.helpers.render.call(this, template, 'model', options)
