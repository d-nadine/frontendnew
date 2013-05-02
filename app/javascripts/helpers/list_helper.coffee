Ember.TEMPLATES['sentence'] = Ember.Handlebars.compile """
  {{#each item in controller}}
    {{link item.content}}{{separator}}
  {{/each}}
"""

Radium.SentenceView = Ember.View.extend
  tagName: "span"

Radium.SentenceController = Radium.ArrayController.extend
  itemController: 'sentenceItem'

Radium.SentenceItemController = Radium.ObjectController.extend
  # HAX, apparently having itemController wraps all the indivdual
  # items in that item controller--thusly the call to taret
  list: Ember.computed.alias('target.content')

  separator: (->
    if @get('list').indexOf(@get('model')) == @get('list.length') - 2
      ' and'
    else if !@get('list.lastObject') == @get('model')
      ', '
  ).property('model')

Ember.Handlebars.registerHelper 'list', (listPath, options) ->
  # Render calls handelbars.get with contexts[1] for some reason.
  # I don't know why, but adding this line fixes it.
  options.contexts[1] = options.contexts[0]

  return Ember.Handlebars.helpers.render.call this, 'sentence', listPath, options
