Radium.AutocompleteView = Radium.View.extend
  actions:
    addSelection: (item) ->
      @get('source').addObject item

    removeSelection: (item) ->
      @get('source').removeObject item

  classNameBindings: [
    'isInvalid'
    'hasUsers:is-valid'
    ':autocomplete'
  ]

  listBinding: 'controller.people'
  isEditableBinding: 'controller.isEditable'
  showAvatar: true
  showAvatarInResults: true
  isSubmitted: Ember.computed.alias('controller.isSubmitted')
  users: Ember.computed.alias('controller.users')
  minChars: 1
  deleteOnBackSpace: true

  template: Ember.Handlebars.compile """
    <ul class="as-selections">
    {{#each view.source}}
      <li {{bind-attr class="view.isEditable :as-selection-item :blur"}}>
        {{#if view.isEditable}}
          <a class="as-close" {{action "removeSelection" this target="view" bubbles=false}}>×</a>
        {{/if}}
        {{#if view.showAvatar}}
          {{avatar this}}
        {{/if}}
        {{#if name}}
          {{name}}
        {{else}}
          {{email}}
        {{/if}}
      </li>
    {{/each}}
      <li class="as-original">
        {{view view.autocomplete}}
      </li>
    </ul>
  """

  resizeInputBox: ->
    input = @$('li.as-original input')

    return unless input

    if @get('isEditable')
      input.show()
    else
      input.hide()

    totalWidth = @$('.as-selections').outerWidth(true)

    last = @$('.as-selections li.as-selection-item:last')

    if last.length
      left = last.position().left + last.outerWidth(true)
    else
      left = @$('.as-selections').position().left

    inputWidth = totalWidth - left

    inputWidth = totalWidth if inputWidth < 100

    input.width inputWidth

  didInsertElement: ->
    @$('input[type=text]').addClass('field')
    @resizeInputBox()

  sourceDidChange: (->
    Ember.run.scheduleOnce 'afterRender', this, "resizeInputBox"
  ).observes('source.[]')

  filterResults: (item) ->
    !@get('source').contains(item)

  retrieve: (query, callback) ->
    list = @get('list')

    return unless list.get('length')

    results = list.filter(@get('parentView').filterResults.bind(this))
                   .map (item) =>
                      @mapSearchResult.call this, item

    callback(results, query)

  selectionAdded: (item) ->
    # create a simple object and let the controller/form how to handle what happens
    if typeof item == "string"
      item = Ember.Object.create
                email: item

    @send('addSelection', item)

  autocomplete: Ember.TextField.extend
    classNameBindings: [':field']
    currentUser: Ember.computed.alias 'targetObject.currentUser'
    sourceBinding: 'parentView.source'
    placeholderBinding: 'parentView.placeholder'
    listBinding: 'parentView.list'
    tabindexBinding: 'parentView.tabindex'

    keyDown: (e) ->
      unless [8, 13].contains e.keyCode
        return @_super.apply this, arguments

      if e.keyCode == 13
        @get('parentView').selectionAdded @get('value')
        @set 'value', ''
        return false


      return @_super.apply(this, arguments) if @get('value').length

      last = @get('source.lastObject')

      return unless last

      @get('parentView').send('removeSelection', last)

      false

    didInsertElement: ->
      Ember.run.scheduleOnce 'afterRender', this, 'addAutocomplete'

    addAutocomplete: ->
      options =
        asHtmlID: @get('elementId')
        selectedItemProp: "name"
        searchObjProps: "name"
        formatList: @formatList.bind(this)
        getAvatar: @getAvatar.bind(this)
        selectionAdded: @get('parentView').selectionAdded.bind(@get('parentView'))
        resultsHighlight: true
        canGenerateNewSelections: true
        usePlaceholder: true
        retrieveLimit: 5
        startText: @get('placeholder')
        keyDelay: 100
        minChars: @get('parentView').get('minChars')

      if @get('parentView').newItemCriteria
        options = $.extend {}, options, newItemCriteria: @get('parentView').newItemCriteria.bind(this)

      @$().autoSuggest {retrieve: @get('parentView').retrieve.bind(this)}, options

    formatList: (data, elem) ->
      content = ""

      if @get('parentView.showAvatarInResults')
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

      email= result.get('email')
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
        value: "#{result.constructor}-#{result.get('id')}"
        name: name
        avatar: avatarUrl
        data: result

    getAvatar: (data) ->
      """
        <img src="#{data.avatar}" title="#{data.name}" class="avatar avatar-small">
      """
