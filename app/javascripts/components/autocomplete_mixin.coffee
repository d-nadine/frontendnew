Radium.AutocompleteMixin = Ember.Mixin.create
  actions:
    updateModel: ->
      return false if @get ('isLoading')
      @_super.apply this, arguments

    setBindingValue: ->
      throw new Error('subclasses need to override setBindingValue')

  isLoading: false

  isAsync: Ember.computed.not 'source'

  matchesSelection: (value) ->
    return unless value
    active  = @$('.typeahead .active')
    if active.is(':visible')
      selected = active.text() || active.val()

    return unless selected
    value?.toLowerCase() == selected?.toLowerCase()

  setValue: (object) ->
    self = this
    el = self.autocompleteElement()

    finish = (value) ->
      self.send 'setBindingValue', object

      # FIXME: find a less hacky way than type checking
      return if self instanceof Radium.AutocompleteTextboxComponent

      isInput = el.get(0).tagName == "INPUT"

      Ember.run.next ->
        if isInput
          el.val value
        else
          el.text value

        self.send 'updateModel'

    if typeof object == "string"
      return finish object

    unless object instanceof DS.Model
      return finish(object.get(@field))

    @set('isLoading', true)
    subject = object.get('person') || object

    observer = =>
      return unless subject.get('isLoaded')

      @set('isLoading', false)
      subject.removeObserver('isLoaded')

      finish(object.get(@field))

    if subject.get('isLoaded')
      observer()
    else
      subject.addObserver('isLoaded', observer)

  getValue: (item) ->
    if typeof item == "string"
      item
    else
      item.get @field

  queryParameters: (query) ->
    scopes = @get('scopes')
    Ember.assert "You need to define a scopes binding for autocomplete", scopes
    params =
      term: query
      scopes: scopes

    return params unless @get('tracked_only')

    params.tracked_only = true

    params

  matcher: (item) ->
    string = @getValue item
    return unless @query
    return unless string
    ~string.toLowerCase().indexOf(@query.toLowerCase())

  sorter: (items) ->
    beginswith = []
    caseSensitive = []
    caseInsensitive = []

    items.forEach (item) =>
      string = @getValue item

      if !string.toLowerCase().indexOf(@query.toLowerCase())
        beginswith.push(item)
      else if (~string.indexOf(@query))
        caseSensitive.push(item)
      else
        caseInsensitive.push(item)

    beginswith.concat caseSensitive, caseInsensitive

  holder: ""

  highlighter: (item) ->
    string = @getValue item

    query = @query.replace(/[\-\[\]{}()*+?.,\\\^$|#\s]/g, '\\$&')
    string.replace new RegExp('(' + query + ')', 'ig'), ($1, match) ->
      "<strong>#{match}</strong>"

  updater: (item) ->
    @set 'value', item

  autocompleteElement: ->
    throw new Error('You must override autocompleteElement in subclass.')

  autocompleteItemType: ->
    @get('autocompleteType') || Radium.AutocompleteItem

  getTypeahead: ->
    @autocompleteElement().data('typeahead')

  asyncSource: (query, process) ->
    queryParameters = @queryParameters(query)

    @set('isLoading', true)

    @autocompleteItemType().find(queryParameters).then((results) =>
      process results
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

    if @getField
      @field = @getField.call this
    else
      @field = @get('queryKey')

    if @bindQuery
      bindingKey = @bindQuery.call this
      binding = Ember.bind this, 'query', bindingKey
    else
      binding = Ember.bind this, 'query', "holder"

    el = @autocompleteElement.call this

    isAsync = @get('isAsync')

    unless @get('source')
      el.typeahead source: @asyncSource.bind(this)
    else
      el.typeahead source: @get('source')

    typeahead = el.data('typeahead')

    isAsync = @get('isAsync')

    typeahead.lookup = (event) ->
      items = undefined

      @query = @$element.text() || @$element.val()

      if isAsync && (not @query or @query.length < @options.minLength)
        if @shown
          return @hide()
        else
          return this

      items = (if $.isFunction(@source) then @source(@query, $.proxy(@process, this)) else @source)

      if !isAsync && !@query && items.get('length')
        return @render(items.slice(0, @options.items)).show()

      (if items then @process(items) else this)

    typeahead.process = (items) ->
      Ember.RSVP.Promise.resolve(items).then =>
        items = items.filter (item) =>
          @matcher(item)

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
