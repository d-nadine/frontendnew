Radium.AutocompleteMixin = Ember.Mixin.create
  actions:
    updateModel: ->
      return false if @get ('isLoading')
      @_super.apply this, arguments

  isLoading: false

  matchesSelection: (value) ->
    return unless value
    active  = @$('.typeahead .active')
    if active.is(':visible')
      selected = active.text() || active.val()

    return unless selected
    value?.toLowerCase() == selected?.toLowerCase()

  setBindingValue: (object) ->
    null

  setValue: (object) ->
    @set('isLoading', true)
    @set('contenteditable', "false")
    person = object.get('person')

    observer = =>
      return unless person.get('isLoaded')

      @set('isLoading', false)
      person.removeObserver('isLoaded')

      @send 'setBindingValue', object

      el = @autocompleteElement()

      isInput = el.get(0).tagName == "INPUT"

      Ember.run.next =>
        if isInput
          el.val object.get(@field)
        else
          el.text object.get(@field)

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

  bindQuery: ->
    throw new Error('You must override bindQuery in subclass.')

  getField: ->
    throw new Error('You must override getField in subclass.')

  autocompleteElement: ->
    throw new Error('You must override autocompleteElement in subclass.')

  asyncSource: (query, process) ->
    queryParameters = @queryParameters(query)

    @set('isLoading', true)

    Radium.AutocompleteItem.find(queryParameters).then((results) =>
      process results
      p results.get('length')
      @set('isLoading', false)

    , Radium.rejectionHandler)
    .then(null, Radium.rejectionHandler)

    null

  showTypeahead: ->
    pos = $.extend({}, @$element.position(), height: @$element[0].offsetHeight)
    @$menu.insertAfter(@$element).css(
      top: pos.top + pos.height
      left: pos.left).show()
    @shown = true
    this

  setup: Ember.on 'didInsertElement', ->
    @_super.apply this, arguments

    @field = @getField.call this

    bindingKey = @bindQuery.call this

    binding = Ember.bind this, 'query', bindingKey

    el = @autocompleteElement.call this

    Ember.assert "No element found in AutocompleteMixin", el.length

    unless @get('sync')
      el.typeahead source: @asyncSource.bind(this)
    else
      el.typeahead source: @get('source')

    typeahead = el.data('typeahead')

    typeahead.lookup = (event) ->
      items = undefined

      @query = @$element.text() || @$element.val()

      return (if @shown then @hide() else this)  if not @query or @query.length < @options.minLength
      items = (if $.isFunction(@source) then @source(@query, $.proxy(@process, this)) else @source)
      (if items then @process(items) else this)

    typeahead.process = (items) ->
      Ember.RSVP.Promise.resolve(items).then =>
        items = items.filter (item) => @matcher(item)

        items = @sorter(items)

        if !items.get('length')
          return if @shown then @hide() else this

        @render(items.slice(0, @options.items)).show()

    typeahead.matcher = @matcher.bind(this)
    typeahead.sorter = @sorter.bind(this)
    typeahead.highlighter = @highlighter.bind(this)

    typeahead.show = @showTypeahead.bind(typeahead)

    typeahead.select = ->
      val = @$menu.find('.active').data('typeahead-value')
      @updater val
      @hide()

    typeahead.updater = (item) =>
      @setValue item
