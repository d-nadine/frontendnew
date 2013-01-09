Radium.FeedSectionView = Em.View.extend
  templateName: 'radium/feed_section'
  classNames: ['feed-section']
  classNameBindings: ['hidden']
  hiddenBinding: 'parentView.hidden'
  justRenderedBinding: 'parentView.justRendered'
  attributeBindings: ['dataDate:data-date']
  dataDateBinding: Ember.Binding.oneWay 'content.id'

  unclustered: (->
    if @get 'disableClusters'
      @get 'content.items'
    else
      @get 'content.unclustered'
  ).property('disableClusters')

  clusters: (->
    if @get 'disableClusters'
      []
    else
      @get 'content.clusters'
  ).property('disableClusters')

  disableClustersBinding: 'controller.disableClusters'

  didInsertElement: ->
    @_super.apply(this, arguments)

    @set 'controller.rendering', false

  notifyCollectionChanged: (name, length) ->
    if parentView = @get('parentView')
      parentView.notifyCollectionChanged(name, length)

  # FIXME: this should go in the view some how but
  # there is some problems with content.date being
  # null at some points...wtf?
  dateHeader: (->
    @get('content.date').toFormattedString('%A, %B %D, %Y')
  ).property('content.date')
