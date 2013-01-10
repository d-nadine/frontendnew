Radium.LimitSupport = Ember.Mixin.create
  limit: 7
  currentLimit: 7

  arrangedContent: (->
    currentLimit = @get 'currentLimit'

    if content = @get('content')
      Ember.A(content.slice(0, currentLimit))
  ).property('content')

  showMore: ->
    currentLimit  = @get 'currentLimit'
    contentLength = @get 'content.length'
    length        = @get 'arrangedContent.length'

    newLimit      = currentLimit + @get('limit')
    newLimit      = contentLength if newLimit > contentLength

    @set 'currentLimit', newLimit

    if length < newLimit
      for i in [(length)..(newLimit - 1)]
        @get('arrangedContent').pushObject( @objectAtContent(i) )

  totalLength: (->
    @get('content.length')
  ).property('content.length')

  contentArrayDidChange: (array, idx, removedCount, addedCount) ->
    if addedCount
      for i in [idx..(idx + addedCount - 1)]
        if @get('arrangedContent.length') < @get('currentLimit')
          @get('arrangedContent').pushObject( @objectAtContent(i) )

    @_super.apply(this, arguments)

  contentArrayWillChange: (array, idx, removedCount, addedCount) ->
    if removedCount
      for i in [idx..(idx + removedCount - 1)]
        @get('arrangedContent').removeObject( @objectAtContent(i) )

    @_super.apply(this, arguments)


  replaceContent: (idx, amt, objects) ->
    @get('content').replace(idx, amt, objects)
