Radium.FeedDetailsContainerView = Ember.ContainerView.extend Radium.Slider,
  contentBinding: 'parentView.content'
  tagName: null

  init: ->
    @_super()

    self = this

    spacerView = Em.View.create
      template: Em.Handlebars.compile('<div><dl class="dl-horizontal"></dl></div>')
    commentsView = Radium.InlineCommentsView.create
      controller: Radium.InlineCommentsController.create
        context: self
        feedItemBinding: 'context.content'

    @get('childViews').pushObject(spacerView)
    @get('childViews').pushObject(commentsView)
