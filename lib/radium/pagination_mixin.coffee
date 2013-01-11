Radium.PaginationMixin = Ember.Mixin.create
  perPage: 7
  currentPage: 1

  currentLimit: (->
    @get('currentPage') * @get('perPage')
  ).property('currentPage', 'perPage')

  limitedContent: (->
    currentLimit = @get 'currentLimit'

    if content = @get('content')
      Ember.A(content.slice(0, currentLimit))
  ).property('content')

  showMore: ->
    currentLimit  = @get 'currentLimit'
    contentLength = @get 'arrangedContent.length'
    length        = @get 'limitedContent.length'

    newLimit      = currentLimit + @get('perPage')
    newLimit      = contentLength if newLimit > contentLength

    @set 'currentLimit', newLimit

    if length < newLimit
      for i in [(length)..(newLimit - 1)]
        @get('limitedContent').pushObject( @objectAtContent(i) )

    @set 'currentPage', @get('currentPage') + 1

  totalLength: (->
    @get('content.length')
  ).property('content.length')

  remainingContent: ( ->
    if content = @get('arrangedContent')
      Ember.A(content.slice(@get('currentLimit') + 1, @get('content.length')))
  ).property('currentLimit')

  contentArrayDidChange: (array, idx, removedCount, addedCount) ->
    if addedCount
      for i in [idx..(idx + addedCount - 1)]
        if @get('limitedContent.length') < @get('currentLimit')
          @get('limitedContent').pushObject( @objectAtContent(i) )

    @_super.apply(this, arguments)

  contentArrayWillChange: (array, idx, removedCount, addedCount) ->
    if removedCount
      for i in [idx..(idx + removedCount - 1)]
        @get('limitedContent').removeObject( @objectAtContent(i) )

    @_super.apply(this, arguments)


  replaceContent: (idx, amt, objects) ->
    @get('content').replace(idx, amt, objects)
