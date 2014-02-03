Radium.ShowMoreMixin = Ember.Mixin.create
  actions:
    showMore: ->
      return unless @get('hiddenContent.length')
      @set 'currentPage', @get('currentPage') + 1

    hasMoreContent: ->
      !!@get('hiddenContent.length')

    reset: ->
      @set 'currentPage', 1

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

  totalLength: (->
    @get('arrangedContent.length')
  ).property('arrangedContent.length')

  hiddenContent: ( ->
    if content = @get('arrangedContent')
      Ember.A(content.slice(@get('currentLimit'), @get('arrangedContent.length')))
  ).property('arrangedContent.[]', 'currentLimit')
