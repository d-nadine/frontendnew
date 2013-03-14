Radium.Typeahead = Ember.TextField.extend
  # Begin typehead customization
  matcher: (item) ->
    string = item.get 'name'
    ~string.toLowerCase().indexOf(@query.toLowerCase())

  sorter: (items) ->
    beginswith = []
    caseSensitive = []
    caseInsensitive = []

    items.forEach (item) =>
      string = item.get 'name'

      if !string.toLowerCase().indexOf(@query.toLowerCase())
        beginswith.push(item)
      else if (~string.indexOf(@query))
        caseSensitive.push(item)
      else
        caseInsensitive.push(item)

    beginswith.concat caseSensitive, caseInsensitive

  highlighter: (item) ->
    string = item.get 'name'

    query = @query.replace(/[\-\[\]{}()*+?.,\\\^$|#\s]/g, '\\$&')
    string.replace new RegExp('(' + query + ')', 'ig'), ($1, match) ->
      "<strong>#{match}</strong>"

  updater: (item) ->
    @set 'value', item

  didInsertElement: ->
    @$().typeahead source: @get('source')

    typeahead = @$().data('typeahead')

    parentView = @get('parentView')
    # make typeahead work with ember arrays
    typeahead.process = (items) ->
      parentView.set 'open', false
      items = items.filter (item) => @matcher(item)

      items = @sorter(items)

      if !items.get('length')
        return if @shown then @hide() else this

      @render(items.slice(0, @options.items)).show()

    typeahead.matcher = @get('matcher')
    typeahead.sorter = @get('sorter')
    typeahead.highlighter = @get('highlighter')

    typeahead.select = ->
      val = @$menu.find('.active').data('typeahead-value')
      @updater val
      @hide()

    typeahead.updater = (item) =>
      @get('parentView').setValue item
