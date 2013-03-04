Radium.AutocompleteView = Ember.View.extend
  classNameBindings: [
    'isInvalid'
    'hasUsers:is-valid'
    ':field'
    ':autocomplete'
  ]

  isSubmitted: Ember.computed.alias('controller.isSubmitted')
  users: Ember.computed.alias('controller.users')

  template: Ember.Handlebars.compile """
    {{view view.autoCompleteList viewName="autoComplete"}}
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
  reset: ->
    @get('autoComplete').reset()

  isInvalid: ( ->
    return false unless @get('isSubmitted')

    not @get('hasUsers')
  ).property('isSubmitted', 'users', 'users.length')

  hasUsers: ( ->
    @get('users.length')
  ).property('users', 'users.length')

  autoCompleteList: Ember.TextField.extend
    currentUser: Ember.computed.alias 'controller.currentUser'
    didInsertElement: ->
      preFill = if @get('controller.isNew')
                  [@mapSearchResult(@get('currentUser'))]
                else
                  @get('controller.source').map( (item) =>
                    @mapSearchResult(item)).toArray()

      @$().autoSuggest {retrieve: @retrieve.bind(this)},
                        selectedItemProp: "name"
                        searchObjProps: "name"
                        preFill: preFill
                        formatList: @formatList.bind(this)
                        getAvatar: @getAvatar.bind(this)
                        selectionClick: @selectionClick.bind(this)
                        selectionAdded: @selectionAdded.bind(this)
                        selectionRemoved: @selectionRemoved.bind(this)
                        resultsHighlight: true
                        canGenerateNewSelections: true

    reset: ->
      @$('as-selection-item a.close').each ->
        $(this).trigger('click')

    selectionRemoved: (el) ->
      @get('controller').removeUserFromMeeting el.data('object')
      el.remove()

    selectionAdded: (el) ->
      if @get('controller.isEditable') && !el.hasClass('is-editable')
        el.addClass('is-editable')

      unless @get('controller.isNew')
        $('.as-close', el).hide()

      attendee = el.data('object')

      # FIXME: Create new contact from unknown email address
      @get('controller').addSelection attendee if attendee

    selectionClick: (el) ->
      return false unless @get('controller.isEditable')

      position = el.position()

      dropdown = el.parents('div.autocomplete:eq(0)').find('.attendeeDropdown')

      dropdown.css
        position: "absolute",
        left: position.left  + "px"
        top: position.top + el.height() + 7 + "px"

      dropdown.find('a:eq(0)').trigger('click.dropdown.data-api')

      event.stopPropagation()

    formatList: (data, elem) ->
      email= data.data.get('email')

      name = if data.name && email
                "#{data.name} (#{email})"
             else if data.name
                data.name
             else
               email

      content = """
        #{@getAvatar(data)}
        #{name}
      """
      elem.html(content)

    retrieve: (query, callback) ->
      people = @get('controller.people')

      return unless people.get('length')

      results = people.map (item) =>
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
