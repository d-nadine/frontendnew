Radium.FormsAutocompleteView = Ember.View.extend
  classNameBindings: [
    'isInvalid'
    'hasUsers:is-valid'
    ':field'
    ':autocomplete'
  ]

  isSubmitted: Ember.computed.alias('controller.isSubmitted')
  users: Ember.computed.alias('controller.users')

  template: Ember.Handlebars.compile """
    {{view view.autoCompleteList}}
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

  isInvalid: ( ->
    return false unless @get('isSubmitted')

    not @get('hasUsers')
  ).property('isSubmitted', 'users', 'users.length')

  hasUsers: ( ->
    @get('users.length') && @get('users.length') > 1
  ).property('users', 'users.length')

  autoCompleteList: Ember.TextField.extend
    didInsertElement: ->
      preFill = if @get('controller.isNew')
                  [@mapUser(@get('controller.currentUser'))]
                else
                  @get('controller.model.users').map( (user) =>
                    @mapUser(user)).toArray()

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

    selectionRemoved: (el) ->
      @get('controller').removeUserFromMeeting el.data('value') + ""
      el.remove()

    selectionAdded: (el) ->
      if @canEdit() && !el.hasClass('is-editable')
        el.addClass('is-editable')

      unless @get('controller.isNew')
        $('.as-close', el).hide()
      @get('controller').addUserToMeeting el.data('value') + ""

    canEdit: ->
      return false if @get('controller.isNew')
      return false unless @get('controller.isEditable')
      return false if @get('controller.hasElapsed')
      true

    selectionClick: (el) ->
      return false unless @canEdit()

      offset = el.offset()

      dropdown = el.parents('div.autocomplete:eq(0)').find('.attendeeDropdown')

      dropdown.css
        position: "absolute",
        top: offset.top + el.height() + 7 + "px",
        left: offset.left + "px"

      dropdown.find('a:eq(0)').trigger('click.dropdown.data-api')
      event.stopPropagation()

    formatList: (data, elem) ->
      content = """
        #{@getAvatar(data)}
        #{data.name}
      """
      elem.html(content)

    retrieve: (query, callback) ->
      # FIXME: Change to real server query
      result = Radium.User.find().map (user) =>
                    @mapUser.call this, user

      callback(result, query)

    mapUser: (user) ->
      currentUser = @get('controller.currentUser')

      name = if user.get('id') == currentUser.get('id')
                "#{user.get('name')} (Me)"
             else
                user.get('name')

      user =
        value: user.get('id')
        name: name
        # FIXME: Get real avatar
        avatar: "/images/default_avatars/small.png"
        data: user

    getAvatar: (data) ->
      """
        <img src="#{data.avatar}" title="#{data.name}" class="avatar avatar-small">
      """
