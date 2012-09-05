Radium.FeedSectionView = Em.View.extend
  templateName: 'feed_section'
  classNames: ['feed-section']
  classNameBindings: ['content.domClass']

  didInsertElement: ->
    @_super.apply(this, arguments)

    @set 'controller.rendering', false
