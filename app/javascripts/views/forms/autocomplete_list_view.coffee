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
      currentUser = @get('controller.currentUser')
      isNew = @get('controller.isNew')

      mapUser = (user) ->
        name = if user.get('id') == currentUser.get('id')
                  "#{user.get('name')} (Me)"
               else
                  user.get('name')

        value: user.get('id')
        name: name
        # FIXME: Get real avatar
        avatar: "/images/default_avatars/small.png"
        data: user

      retrieve = (query, callback) =>
        # FIXME: Change to real server query
        result = Radium.User.find().map mapUser

        callback(result, query)

      getAvatar = (data) ->
        """
          <img src="#{data.avatar}" title="#{data.name}" class="avatar avatar-small">
        """

      formatList = (data, elem) ->
        content = """
          #{getAvatar(data)}
          #{data.name}
        """

        elem.html(content)

      selectionClick = (el) =>
        console.log el

      selectionAdded = (el) =>
        unless isNew
          $('.as-close', el).hide()
        @get('controller').addUserToMeeting el.data('value') + ""

      selectionRemoved = (el) =>
        @get('controller').removeUserFromMeeting el.data('value') + ""
        el.remove()

      preFill = if @get('controller.model.isNew')
                  [mapUser(currentUser)]
                else
                  @get('controller.model.users').map( (user) ->
                    mapUser(user)).toArray()

      @$().autoSuggest {retrieve: retrieve},
                        selectedItemProp: "name"
                        searchObjProps: "name"
                        preFill: preFill
                        formatList: formatList
                        getAvatar: getAvatar
                        selectionClick: selectionClick
                        selectionAdded: selectionAdded
                        selectionRemoved: selectionRemoved
                        resultsHighlight: true
