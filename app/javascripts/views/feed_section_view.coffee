Radium.FeedSectionView = Em.View.extend
  templateName: 'feed_section'
  classNames: ['feed-section']
  classNameBindings: ['content.domClass', 'hidden']
  hiddenBinding: 'parentView.hidden'
  justRenderedBinding: 'parentView.justRendered'

  didInsertElement: ->
    @_super.apply(this, arguments)

    @set 'controller.rendering', false

  notifyCollectionChanged: (name, length) ->
    if parentView = @get('parentView')
      parentView.notifyCollectionChanged(name, length)
