Radium.ShowMoreMixin = Ember.Mixin.create
  perPage: 7
  currentPage: 1

  currentLimit: (->
    currentLimit = @get('currentPage') * @get('perPage')

    return currentLimit if @get('currentPage') == 1

    contentLength = @get('arrangedContent.length')

    if currentLimit > contentLength
      contentLength
    else
      currentLimit
  ).property('currentPage', 'perPage')

  visibleContent: (->
    currentLimit = @get 'currentLimit'

    if content = @get('arrangedContent')
      Ember.A(content.slice(0, currentLimit))
  ).property('arrangedContent.length', 'currentLimit')

  showMore: ->
    return unless @get('hiddenContent.length')
    @set 'currentPage', @get('currentPage') + 1

  totalLength: (->
    @get('arrangedContent.length')
  ).property('arrangedContent.length')

  hiddenContent: ( ->
    if content = @get('arrangedContent')
      Ember.A(content.slice(@get('currentLimit') + 1, @get('arrangedContent.length')))
  ).property('arrangedContent.length', 'currentLimit')

  hasMoreContent: ->
    !!@get('hiddenContent.length')

  reset: ->
    @set 'currentPage', 1

  contentArrayDidChange: (array, idx, removedCount, addedCount) ->
    @_super.apply this, arguments
    @set 'currentPage', 1


