Radium.FormsAutocompleteView = Ember.TextField.extend
  didInsertElement: ->
    currentUser = @get('controller.currentUser')

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

    selectionClick = (ele) =>
      console.log ele

    @$().autoSuggest {retrieve: retrieve},
                      selectedItemProp: "name"
                      searchObjProps: "name"
                      preFill: [mapUser(currentUser)]
                      formatList: formatList
                      getAvatar: getAvatar
                      selectionClick: selectionClick
