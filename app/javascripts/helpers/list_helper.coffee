Ember.TEMPLATES['sentence'] = Ember.Handlebars.compile """
  {{#each controller}}
    {{resource-link-to "model"}}{{separator}}
  {{/each}}
"""

Radium.SentenceView = Ember.View.extend
  tagName: "span"

Radium.SentenceController = Radium.ArrayController.extend
  itemController: 'sentenceItem'

Radium.SentenceItemController = Radium.ObjectController.extend
  list: Ember.computed.alias('parentController.content')

  separator: (->
    if @get('list').indexOf(@get('model')) == @get('list.length') - 2
      ' and'
    else if !@get('list.lastObject') == @get('model')
      ', '
  ).property('model')

Ember.Handlebars.registerHelper 'list', (listPath, options) ->
  options.types[0] = "STRING"
  # Render calls handelbars.get with contexts[1] for some reason.
  # I don't know why, but adding this line fixes it.
  options.contexts[1] = options.contexts[0]

  return Ember.Handlebars.helpers.render.call this, 'sentence', listPath, options
