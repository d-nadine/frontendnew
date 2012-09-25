Radium.FeedSectionsListView = Ember.CollectionView.extend
  contentWillChange: ->
    @_super.apply(this, arguments)

    @set 'controller.rendering', true

  arrayDidChange: ->
    @_super.apply(this, arguments)

    previous = null
    @get('childViews').forEach (view) ->
      if previous
        view.set('nextView', previous)
        previous.set('previousView', view)
      previous = view

  arrayWillChange: ->
    @_super.apply(this, arguments)

    previous = null
    @get('childViews').forEach (view) ->
      if previous
        view.set('nextView', previous)
        previous.set('previousView', view)
      previous = view

  itemViewClass: Em.ContainerView.extend
    init: ->
      @_super.apply(this, arguments)

      @set 'currentView', Radium.FeedSectionView.create(contentBinding: 'parentView.content')
      @set 'emptyCollections', Ember.A([])

    hideFilteredView: () ->
      filteredInfoView = @get('filteredInfoView')
      @get('childViews').removeObject(filteredInfoView)

    displayFilteredView: () ->
      filteredInfoView = @get('filteredInfoView') || @createFilteredInfoView()
      @get('childViews').unshiftObject(filteredInfoView)

    createFilteredInfoView: () ->
      filteredInfoView = Radium.FilteredItemsInfoView.create
        contentBinding: "parentView.content"

      @set 'filteredInfoView', filteredInfoView
      filteredInfoView

    didInsertElement: ->
      @_super.apply(this, arguments)
      # FIXME: for some weird reason gapObserver is not fired when
      #        inserting element, I'm not really sure why, but don't
      #        want to waste much more time investigating it
      @checkGapView()
      @showOrHideFilteredView()

      @set 'justRendered', true

      @adjustScroll()

    adjustScroll: ->
      if @get('parentView.content.firstObject') == @get('content')
        # we're the first element
        scroll = document.body.scrollTop + this.$().height() + 2
        window.scrollTo 0, scroll

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


    showOrHideFilteredView: (->
      if @get 'filteredViewExpanded'
        @displayFilteredView()
      else
        @hideFilteredView()
    ).observes('filteredViewExpanded')

    toggleFilteredViewExpanded: (->
      filteredViewExpanded = @get 'filteredViewExpanded'

      newValue = @get('hidden') && @get('justRendered') && !@get('nextView.filtered')

      if filteredViewExpanded != newValue
        @set 'filteredViewExpanded', newValue
    ).observes('hidden', 'justRendered', 'nextView.filtered')

    filtered: (->
      @get('hidden') && @get('justRendered')
    ).property('hidden', 'justRendered')

    filteredViewsCount: (->
      if @get('previousView.filtered')
        @get('previousView.filteredViewsCount') + 1
      else if !@get('previousView.filtered')
        1
      else
        0
    ).property('previousView.filteredViewsCount', 'previousView.filtered')

    # Content of collections inside section view is filtered in the views,
    # so it's hard to hide it based on watching filtered elements length.
    # Also, in the future section will contain other items, like
    # historical section. That's why I notify this view about
    # collections length and act accordingly. This is not strictly the
    # ember way of doing things, but I can't think of anything better
    # at the moment
    hidden: (->
      @get('nestedCollectionsCount') == @get('emptyCollections.length')
    ).property('nestedCollectionsCount', 'emptyCollections.length')

    nestedCollectionsCount: 2

    notifyCollectionChanged: (name, length) ->
      emptyCollections = @get('emptyCollections')
      if length
        emptyCollections.removeObject(name)
      else
        emptyCollections.pushObject(name) unless emptyCollections.contains(name)
