Radium.FeedDetailsContainerView = Ember.ContainerView.extend Radium.Slider,
  contentBinding: 'parentView.content'
  tagName: null

  init: ->
    @_super()

    self = this

    commentsView = Radium.InlineCommentsView.create
      controller: Radium.InlineCommentsController.create
        context: self
        feedItemBinding: 'context.content'

    @get('childViews').pushObject(commentsView)
