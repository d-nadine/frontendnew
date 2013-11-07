Radium.SidebarUserHeaderView = Radium.InlineEditorView.extend
  userFirstName: Ember.TextField.extend
    keyDown: (evt) ->
      unless evt.keyCode == 9
        @_super.apply this, arguments
        return

      @get('parentView.lastName').$().focus()
      return false

  userLastName: Ember.TextField.extend
    keyDown: (evt) ->
      unless evt.keyCode == 9
        @_super.apply this, arguments
        return

      @get('parentView.title').$().focus()
      return false

  userTitle: Ember.TextField.extend
    keyDown: (evt) ->
      unless evt.keyCode == 9
        @_super.apply this, arguments
        return

      @get('parentView.firstName').$().focus()
      return false
