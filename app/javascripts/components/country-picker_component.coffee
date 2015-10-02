require 'components/autocomplete_mixin'

Radium.CountryPickerComponent = Ember.Component.extend Radium.AutocompleteMixin,
  actions:
    changeCountry: (country) ->
      @set 'open', false
      @sendAction "changeCountry", country

    toggleDropdown: ->
      typeahead = @getTypeahead()

      if typeahead.shown
        typeahead.hide()
        return false
      else
        # FIXME: Do we move this into automcomplete mixin?
        # so we can show typeahead on click?
        typeahead.options.minLength = 0
        typeahead.options.items = Radium.Countries.length
        typeahead.show()
        typeahead.lookup()
        typeahead.$element.focus()
        return true

  setValue: (country) ->
    @send "changeCountry", country

  classNameBindings: [":country-picker", "open"]

  getField: ->
    'label'

  input: (e) ->
    @set('open', false) if @get('open')

    el = @autocompleteElement()

    @set 'query', el.val()

  autocompleteElement: ->
    @$('input[type=text]:first')

  focusOut: (e) ->
    cantComplete = (value) ->
      value.isDestroyed || value.isDestroying || !value.get('open')

    return if cantComplete(this)

    Ember.run.later =>
      @set('open', false) unless cantComplete(this)
    , 200

  focusIn: ->
    Em.run.next =>
      @autocompleteElement()?.select()

  click: (event) ->
    event.stopPropagation()

  sync: true

  matcher: (item) ->
    query = @resolveQuery(@query) || ""

    unless query.length
      return true

    @_super.apply this, arguments

  sorter: (items) ->
    query = @resolveQuery(@query) || ""

    unless query.length
      return items

    @_super.apply this, arguments

  source: Ember.computed 'countryList.[]', ->
    @get('countryList').map (c) -> Ember.Object.create(c)

  highlighter: (item) ->
    string = item.get @field

    query = @query.replace(/[\-\[\]{}()*+?.,\\\^$|#\s]/g, '\\$&')
    result = string.replace new RegExp('(' + query + ')', 'ig'), ($1, match) ->
      "<strong>#{match}</strong>"

    if item?.key.length
      key = item.key.substr(0, 2)
      flag = "<i class=\"glyphicon bfh-flag-#{key}\"></i>"
    else
      flag = ""

    symbol = item?.symbol || ""

    result = "#{flag} #{result} <strong>#{symbol}</strong>"

  showTypeahead: ->
    pos = $.extend({}, @$element.position(), height: @$element[0].offsetHeight)
    left = pos.left - 13

    @$menu.insertAfter(@$element).css(
      top: pos.top + pos.height
      left: left).show()
    @shown = true
    this

  _setup: Ember.on 'didInsertElement', ->
    @_super.apply this, arguments
    
