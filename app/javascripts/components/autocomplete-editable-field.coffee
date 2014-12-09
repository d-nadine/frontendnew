require 'components/editable-field_component'

Radium.AutocompleteEditableFieldComponent = Radium.EditableFieldComponent.extend
  actions:
    updateModel: ->
      return false if @get ('isLoading')
      @_super.apply this, arguments

  isLoading: false

  matchesSelection: (value) ->
    return unless value
    active  = @$('.typeahead .active')
    selected = active.text() if active.is(':visible')
    return unless selected
    value?.toLowerCase() == selected?.toLowerCase()

  setValue: (object) ->
    @set('isLoading', true)
    @set('contenteditable', "false")
    person = object.get('person')

    observer = =>
      return unless person.get('isLoaded')

      @set('isLoading', false)
      @set('contenteditable', "true")
      person.removeObserver('isLoaded')
      @set "bufferedProxy.#{@get('bufferKey')}", object.get(@field)

      Ember.run.next =>
        @$().text object.get(@field)
        @send 'updateModel'

    if person.get('isLoaded')
      observer()
    else
      person.addObserver('isLoaded', observer)

  queryParameters: (query) ->
    scopes = @get('scopes')
    Ember.assert "You need to define a scopes binding for autocomplete", scopes
    term: query
    scopes: scopes

  # Begin typeahead customization
  matcher: (item) ->
    string = item.get @field
    return unless @query
    ~string.toLowerCase().indexOf(@query.toLowerCase())

  sorter: (items) ->
    beginswith = []
    caseSensitive = []
    caseInsensitive = []

    items.forEach (item) =>
      string = item.get @field

      if !string.toLowerCase().indexOf(@query.toLowerCase())
        beginswith.push(item)
      else if (~string.indexOf(@query))
        caseSensitive.push(item)
      else
        caseInsensitive.push(item)

    beginswith.concat caseSensitive, caseInsensitive

  highlighter: (item) ->
    string = item.get @field

    query = @query.replace(/[\-\[\]{}()*+?.,\\\^$|#\s]/g, '\\$&')
    string.replace new RegExp('(' + query + ')', 'ig'), ($1, match) ->
      "<strong>#{match}</strong>"

  updater: (item) ->
    @set 'value', item

  setup: Ember.on 'didInsertElement', ->
    @_super.apply this, arguments

    @field = @get('queryKey') || @get('bufferKey')

    bufferKey = @get('bufferKey')
    bufferDep = "bufferedProxy.#{bufferKey}"

    binding = Ember.bind this, 'query', bufferDep

    @$().typeahead source: (query, process) =>
      queryParameters = @queryParameters(query)

      @set('isLoading', true)

      Radium.AutocompleteItem.find(queryParameters).then((results) =>
        process results
        @set('isLoading', false)

      , Radium.rejectionHandler)
      .then(null, Radium.rejectionHandler)

      null

    typeahead = @$().data('typeahead')

    typeahead.lookup = (event) ->
      items = undefined
      @query = @$element.text()
      return (if @shown then @hide() else this)  if not @query or @query.length < @options.minLength
      items = (if $.isFunction(@source) then @source(@query, $.proxy(@process, this)) else @source)
      (if items then @process(items) else this)

    # make typeahead work with ember arrays
    typeahead.process = (items) ->
      items.then =>
        items = items.filter (item) => @matcher(item)

        items = @sorter(items)

        if !items.get('length')
          return if @shown then @hide() else this

        @render(items.slice(0, @options.items)).show()

    typeahead.matcher = @matcher.bind(this)
    typeahead.sorter = @sorter.bind(this)
    typeahead.highlighter = @highlighter.bind(this)

    typeahead.select = ->
      val = @$menu.find('.active').data('typeahead-value')
      @updater val
      @hide()

    typeahead.updater = (item) =>
      @setValue item