Radium.FeedSectionsListView = Ember.CollectionView.extend
  contentWillChange: ->
    @_super.apply(this, arguments)

    @set 'controller.rendering', true

  itemViewClass: Em.ContainerView.extend
    init: ->
      @_super.apply(this, arguments)

      @set 'currentView', Radium.FeedSectionView.create(contentBinding: 'parentView.content')

    didInsertElement: ->
      # FIXME: for some weird reason gapObserver is not fired when
      #        inserting element, I'm not really sure why, but don't
      #        want to waste much more time investigating it
      @checkGapView()

    gapObserver: (->
      @checkGapView()
    ).observes('gap')

    checkGapView: ->
      if @get('gap')
        gapView = @get('gapView') || @createGapView()
        @get('childViews').unshiftObject gapView
      else
        if gapView = @get('gapView')
          @get('childViews').removeObject gapView

    gap: (->
      if content = @get('content')
        @get('parentView.content.firstObject') != content &&
          content.get('nextDate') && !content.get('nextSection')
    ).property('content', 'content.nextSection', 'content.nextDate', 'parentView.content.firstObject')

    createGapView: ->
      gapView = Radium.GapView.create()
      @set 'gapView', gapView
      gapView
