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

  currentLimit: Ember.computed 'currentPage', 'perPage', ->
    currentLimit = @get('currentPage') * @get('perPage')

    return currentLimit if @get('currentPage') == 1

    contentLength = @get('arrangedContent.length')

    if currentLimit > contentLength
      contentLength
    else
      currentLimit

  visibleContent: Ember.computed 'arrangedContent.length', 'currentLimit', ->
    currentLimit = @get 'currentLimit'

    if content = @get('arrangedContent')
      Ember.A(content.slice(0, currentLimit))

  totalLength: Ember.computed 'arrangedContent.length', ->
    @get('arrangedContent.length')

  hiddenContent: Ember.computed 'arrangedContent.[]', 'currentLimit', ->
    if content = @get('arrangedContent')
      Ember.A(content.slice(@get('currentLimit'), @get('arrangedContent.length')))
