require 'radium/templates/feed'

Radium.FeedView = Em.View.extend
  templateName: 'feed'
  elementId: 'feed'
  feedBinding: 'controller.content'
