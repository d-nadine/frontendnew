Radium.FeedDetailsContainerView = Ember.ContainerView.extend Radium.Slider,
  contentBinding: 'parentView.content'
  tagName: null

  init: ->
    @_super()

    type = @get('type')

    infoView = Ember.View.create
      contentBinding: 'parentView.content'
      layoutName: 'layouts/feed_item_details'
      init: ->
        @_super()
        @set('templateName', type + '_details')

    commentsView = Radium.InlineCommentsView.create
      controller: Radium.InlineCommentsController.create
        context: this
        feedItemBinding: 'context.content'

    @get('childViews').pushObject infoView
    @get('childViews').pushObject commentsView
