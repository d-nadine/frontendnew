require 'radium/templates/feed'

Radium.FeedView = Em.View.extend
  templateName: 'feed'
  elementId: 'feed'
  feedBinding: 'controller.content'
  emptyView: Em.View.extend
    template: Em.Handlebars.compile('Nothing is here, you can add stuff')
