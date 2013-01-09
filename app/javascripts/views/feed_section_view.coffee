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

  dateHeader: (->
    # TODO: it should be probably done by using presenters,
    #       but not sure if worth it at the moment
    range = @get 'controller.range'
    if range == 'daily'
      @get('content.date').toFormattedString('%A, %B %D, %Y')
    else
      date    = @get('content.date')
      endDate = @get('content.endDate')

      "#{date.toFormattedString('%Y-%m-%d')} - #{endDate.toFormattedString('%Y-%m-%d')}"
  ).property('content.date', 'content.endDate')
