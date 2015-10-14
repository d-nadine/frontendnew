require 'components/key_constants_mixin'

Radium.XAutosuggestComponent = Ember.Component.extend
  actions:
    addSelection: (item) ->
      if @get('searchOnlyAction')
        @sendAction "searchOnlyAction", item

      if @get('addSelection')
        return @sendAction "addSelection", item

      @get('destination').addObject item

    removeSelection: (item) ->
      if @get('removeSelection')
        return @sendAction "removeSelection", item

      @get('destination').removeObject item

    itemAction: (item) ->
      return unless @get('itemAction')

      @sendAction "itemAction", item

      false

  classNameBindings: [
    'isInvalid'
    'isValid'
    'hasUsers:is-valid'
    ':autocomplete'
  ]

  showAvatar: true
  showAvatarInResults: true
  minChars: 1
  deleteOnBackSpace: true

  abortResize: false

  resizeInputBox: ->
    input = @$('li.as-original input')

    return unless input

    if @get('abortResize')
      return input.width(50)

    totalWidth = @$('.as-selections').outerWidth(true)

    last = @$('.as-selections li.as-selection-item:last')

    if last.length
      left = last.position().left + last.outerWidth(true)
    else
      left = @$('.as-selections').position().left

    inputWidth = totalWidth - left

    inputWidth = totalWidth if inputWidth < 100

    input.width inputWidth

  _setup: Ember.on 'didInsertElement', ->
    @_super.apply this, arguments
    @$('input[type=text]').addClass('field')
    @resizeInputBox()

  _teardown: Ember.on 'willDestroyElement', ->
    @_super.apply this, arguments

  destinationDidChange: Ember.observer 'destination.[]', ->
    Ember.run.scheduleOnce 'afterRender', this, "resizeInputBox"

  filterResults: (item) ->
    !@get('destination').contains(item)

  retrieve: (query, callback) ->
    source = @get('source')

    return unless source.get('length')

    results = source.filter(@get('targetObject').filterResults.bind(this))
                   .map (item) =>
                      @mapSearchResult.call this, item

    callback(results, query)

  selectionAdded: (item) ->
    if typeof item == "string"
      item = Ember.Object.create
                email: item

    @send('addSelection', item)

  newItemCriteria: (text) ->
    Radium.EMAIL_REGEX.test text

  allowSpaces: false

  autocomplete: Ember.TextField.extend Radium.KeyConstantsMixin,
    classNameBindings: [':field']
    currentUser: Ember.computed.alias 'targetObject.currentUser'
    destinationBinding: 'targetObject.destination'
    placeholderBinding: 'targetObject.placeholder'
    sourceBinding: 'targetObject.source'
    tabindexBinding: 'targetObject.tabindex'
    deleteOnBackSpace: Ember.computed.oneWay 'targetObject.deleteOnBackSpace'

    keyDown: (e) ->
      args = Array.prototype.slice.call(arguments)

      callSuper = =>
        @_super.apply this, args

      unless [@DELETE, @ENTER, @SPACE].contains e.keyCode
        return callSuper()

      value = @get('value') || ''

      targetObject = @get('targetObject')

      if e.keyCode == @SPACE && targetObject.get('allowSpaces')
        return callSuper()

      if e.keyCode == @ENTER && targetObject.get('searchOnlyAction')
        targetObject.sendAction "searchOnlyAction", value
        return false

      if [@SPACE, @ENTER].contains e.keyCode
        unless @get('targetObject').newItemCriteria(value)
          return callSuper()

        @get('targetObject').selectionAdded value
        @set 'value', ''
        return false

      return callSuper() if value.length

      return unless @get('deleteOnBackSpace')

      last = @get('destination.lastObject')

      return unless last

      @get('targetObject').send('removeSelection', last)

      false

    focusOut: (e) ->
      Ember.run.next =>
        el = @$()

        return unless el && el.length

        targetObject = @get('targetObject')

        value = $.trim(el.val() || '')

        return unless targetObject.newItemCriteria(value)

        targetObject.selectionAdded value

        el.val('')

    didInsertElement: ->
      @_super.apply this, arguments
      Ember.run.scheduleOnce 'afterRender', this, 'addAutocomplete'

    addAutocomplete: ->
      options =
        asHtmlID: @get('elementId')
        selectedItemProp: "name"
        searchObjProps: "name"
        formatList: @formatList.bind(this)
        getAvatar: @getAvatar.bind(this)
        selectionAdded: @get('targetObject').selectionAdded.bind(@get('targetObject'))
        resultsHighlight: true
        canGenerateNewSelections: true
        usePlaceholder: true
        retrieveLimit: 8
        startText: @get('placeholder')
        keyDelay: 100
        minChars: @get('targetObject').get('minChars')

      if @get('targetObject').newItemCriteria
        options = $.extend {}, options, newItemCriteria: @get('targetObject').newItemCriteria.bind(this)

      @$().autoSuggest {retrieve: @get('targetObject').retrieve.bind(this)}, options

    formatList: (data, elem) ->
      content = ""

      if @get('targetObject.showAvatarInResults')
        content = """
          #{@getAvatar(data)}
          #{data.name}
        """
      else
        content = """
          #{data.name}
        """

      elem.html(content)

    mapSearchResult: (result) ->
      currentUser = @get('currentUser')

      email = result.get('email')
      name = result.get('name')

      name = if name && email
                "#{name} (#{email})"
             else if name
                name
             else
               email

      name = if !result.get('isExternal') && result.get('person')?.constructor == Radium.User && result.get('id') == currentUser.get('id')
                "#{name} (Me)"
             else
               name

      avatarUrl = if result.get('avatarKey')
                    "http://res.cloudinary.com/radium/image/upload/c_fit,h_32,w_32/#{result.get('avatarKey')}.jpg"
                  else
                    "/images/default_avatars/small.png"

      result =
        id: result.get('id')
        value: "#{result.constructor}-#{result.get('id')}"
        name: name
        avatar: avatarUrl
        data: result

    getAvatar: (data) ->
      """
        <img src="#{data.avatar}" title="#{data.name}" class="avatar avatar-small">
      """
