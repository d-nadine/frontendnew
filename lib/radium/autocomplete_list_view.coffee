Radium.AutocompleteView = Radium.View.extend
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

  template: Ember.Handlebars.compile """
    <ul class="as-selections">
    {{#each view.source}}
      <li {{action showContextMenu this target="view"}} {{bindAttr class="view.isEditable :as-selection-item :blur"}}>
        {{#if view.isEditable}}
          <a class="as-close" {{action removeSelection this target="view"}}>×</a>
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
    <div class="attendeeDropdown" class="dropdown">
      <a class="dropdown-toggle" data-toggle="dropdown" href="#">
        link<b class="caret"></b>
      </a>
      <div class="attendeeMenu dropdown-menu">
        <table>
          <tr>
            <td><a href="#">Remove Attendee</a></td>
            <td><a href="#">Resend Invite</a></td>
          </tr>
        </table>
      </div>
    </div>
  """

  focus: ->
    @$('li.as-original input').focus()

  showContextMenu: (attendee) ->
    return false unless @get('isEditable')

    el = $(event.srcElement)

    position = el.position()

    dropdown = el.parents('div.autocomplete:eq(0)').find('.attendeeDropdown')

    dropdown.css
      position: "absolute",
      left: position.left  + "px"
      top: position.top + el.height() + 7 + "px"

    dropdown.find('a:eq(0)').trigger('click.dropdown.data-api')

    event.stopPropagation()

  addSelection: (item) ->
    @get('source').addObject item

  removeSelection: (item) ->
    @get('source').removeObject item

  sourceDidChange: (->
    Ember.run.scheduleOnce 'afterRender', this, "resizeInputBox"
  ).observes('source.[]')

  # FIXME: change the markup to use a div so we
  # can use block level like normal
  resizeInputBox: ->
    # totalWidth = @$('as-selections').outerWidth(true)

    # selectionWidth = 0

    # @$('li.as-selection-item').each ->
    #   selectionWidth = selectionWidth + $(this).outerWidth(true)

    # inputWidth = totalWidth - selectionWidth - 41

    # @$('li.as-original input').width inputWidth

  didInsertElement: ->
    @$('input[type=text]').addClass('field')
    @resizeInputBox()

  autocomplete: Ember.TextField.extend
    classNameBindings: [':field']
    currentUser: Ember.computed.alias 'controller.currentUser'
    sourceBinding: 'parentView.source'
    placeholderBinding: 'parentView.placeholder'
    listBinding: 'parentView.list'
    tabindexBinding: 'parentView.tabindex'

    didInsertElement: ->
      options =
        asHtmlID: @get('elementId')
        selectedItemProp: "name"
        searchObjProps: "name"
        formatList: @formatList.bind(this)
        getAvatar: @getAvatar.bind(this)
        selectionAdded: @selectionAdded.bind(this)
        resultsHighlight: true
        canGenerateNewSelections: true
        usePlaceholder: true
        retrieveLimit: 5
        startText: @get('placeholder')

      if @get('parentView').newItemCriteria
        options = $.extend {}, options, newItemCriteria: @get('parentView').newItemCriteria.bind(this)

      if @get('parentView').selectionAdded
        options = $.extend {}, options, selectionAdded: @get('parentView').selectionAdded.bind(this)

      @$().autoSuggest {retrieve: @retrieve.bind(this)}, options

    selectionAdded: (item) ->
      # FIXME create new contact while meeting is being saved
      if typeof item == "string"
        item = Ember.Object.create
                  email: item

      @get('parentView').addSelection item

    formatList: (data, elem) ->
      email= data.data.get('email')

      name = if data.name && email
                "#{data.name} (#{email})"
             else if data.name
                data.name
             else
               email

      content = ""

      if @get('parentView.showAvatarInResults')
        content = """
          #{@getAvatar(data)}
          #{name}
        """
      else
        content = """
          #{name}
        """

      elem.html(content)

    retrieve: (query, callback) ->
      list = @get('list')

      return unless list.get('length')

      results = list.filter( (item) =>
                        @get('source').indexOf(item) == -1
                     ).map (item) =>
                        @mapSearchResult.call this, item

      callback(results, query)

    mapSearchResult: (result) ->
      currentUser = @get('currentUser')

      name = if result.constructor == Radium.User && result.get('id') == currentUser.get('id')
                "#{result.get('name')} (Me)"
             else
                result.get('name') || result.get('email')

      result =
        value: "#{result.constructor}-#{result.get('id')}"
        name: name
        # FIXME: Get real avatar
        avatar: "/images/default_avatars/small.png"
        data: result

    getAvatar: (data) ->
      unless data.data
        data.avatar = "/images/default_avatars/small.png"
      """
        <img src="#{data.avatar}" title="#{data.name}" class="avatar avatar-small">
      """
