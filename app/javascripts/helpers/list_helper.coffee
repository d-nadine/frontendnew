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
  list: Ember.computed.oneWay('parentController.content')

  separator: Ember.computed ->
    if @get('list').indexOf(@get('model')) == @get('list.length') - 2
      ' and'
    else if !@get('list.lastObject') == @get('model')
      ', '

Ember.Handlebars.registerHelper 'list', (listPath, options) ->
  options.types[0] = "STRING"
  options.contexts[1] = options.contexts[0]

  return Ember.Handlebars.helpers.render.call this, 'sentence', listPath, options
