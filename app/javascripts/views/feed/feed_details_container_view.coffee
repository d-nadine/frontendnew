require 'radium/mixins/views/slider'
require 'radium/views/comments/inline_comments_view'
require 'radium/controllers/inline_comments_controller'

Radium.FeedDetailsContainerView = Ember.ContainerView.extend Radium.Slider,
  contentBinding: 'parentView.content'
  tagName: null

  init: ->
    @_super()

    type = @get('type')

    infoView = Ember.View.create
      contentBinding: 'parentView.content'
      layoutName: 'radium/layouts/feed_item_details'
      init: ->
        @_super()
        @set('templateName', "radium/feed/details/#{type}")

    commentsView = Radium.InlineCommentsView.create
      controller: Radium.InlineCommentsController.create
        context: this
        feedItemBinding: 'context.content'

    @get('childViews').pushObject infoView
    @get('childViews').pushObject commentsView
