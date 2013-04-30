Radium.ShowMoreMixin = Ember.Mixin.create
  perPage: 7
  currentPage: 1

  currentLimit: (->
    @get('currentPage') * @get('perPage')
  ).property('currentPage', 'perPage')

  visibleContent: (->
    currentLimit = @get 'currentLimit'

    if content = @get('arrangedContent')
      Ember.A(content.slice(0, currentLimit))
  ).property('arrangedContent.length', 'currentLimit')

  showMore: ->
    currentLimit  = @get 'currentLimit'
    contentLength = @get 'arrangedContent.length'
    length        = @get 'visibleContent.length'

    newLimit      = currentLimit + @get('perPage')
    newLimit      = contentLength if newLimit > contentLength

    @set 'currentLimit', newLimit
    @set 'currentPage', @get('currentPage') + 1

  totalLength: (->
    @get('arrangedContent.length')
  ).property('arrangedContent.length')

  hiddenContent: ( ->
    if content = @get('arrangedContent')
      Ember.A(content.slice(@get('currentLimit') + 1, @get('arrangedContent.length')))
  ).property('arrangedContent.length', 'currentLimit')

  contentArrayDidChange: (array, idx, removedCount, addedCount) ->
    @_super.apply this, arguments
    @set 'currentPage', 1
