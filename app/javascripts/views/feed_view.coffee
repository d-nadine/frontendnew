require 'radium/templates/feed'

Radium.FeedView = Em.View.extend
  templateName: 'feed'
  elementId: 'feed'
  feedBinding: 'controller'
  empty: (->
    @get('feed.length') == 0 ||
      !@get('feed').find( (section) -> section.get('items.length') > 0 )
  ).property('feed', 'feed.@each.items.@each.length')
  emptyView: Em.View.extend
    templateName: 'empty_feed'
