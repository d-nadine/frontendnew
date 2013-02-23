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
    getAvatar: (data) ->
      """
        <img src="#{data.avatar}" title="#{data.name}" class="avatar avatar-small">
      """
    selectionRemoved: (el) ->
      console.log 'yip'
      @get('controller').removeUserFromMeeting el.data('value') + ""
      el.remove()

    selectionAdded: (el) ->
      unless @get('controller.isNew')
        $('.as-close', el).hide()
      @get('controller').addUserToMeeting el.data('value') + ""

    selectionClick: (el) ->
      return if @get('controller.isNew')
      offset = el.offset()

      dropdown = el.parents('div.autocomplete:eq(0)').find('.attendeeDropdown')

      dropdown.css
        position: "absolute",
        top: offset.top + el.height() + 7 + "px",
        left: offset.left + "px"

      dropdown.find('a:eq(0)').trigger('click.dropdown.data-api')
      event.stopPropagation()

    retrieve: (query, callback) ->
      # FIXME: Change to real server query
      result = Radium.User.find().map @mapUser

      callback(result, query)

    formatList: (data, elem) ->
      content = """
        #{getAvatar(data)}
        #{data.name}
      """
      elem.html(content)

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

    didInsertElement: ->
      preFill = if @get('controller.model.isNew')
                  [@mapUser(@get('controller.currentUser'))]
                else
                  @get('controller.model.users').map( (user) =>
                    @mapUser(user)).toArray()

      @$().autoSuggest {retrieve: $.proxy(@retrieve, this)},
                        selectedItemProp: "name"
                        searchObjProps: "name"
                        preFill: preFill
                        formatList: $.proxy(@formatList, this)
                        getAvatar: $.proxy(@getAvatar, this)
                        selectionClick: $.proxy(@selectionClick, this)
                        selectionAdded: $.proxy(@selectionAdded, this)
                        selectionRemoved: $.proxy( @selectionRemoved, this)
                        resultsHighlight: true
