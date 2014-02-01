require 'lib/radium/contact_company_picker'

Radium.SidebarContactHeaderView = Radium.InlineEditorView.extend
  isEditable: Ember.computed.alias 'controller.isEditable'
  contactName: Ember.TextField.extend
    keyDown: (evt) ->
      unless evt.keyCode == 9
        @_super.apply this, arguments
        return

      @get('parentView.title').$().focus()
      return false

   contactTitle: Ember.TextField.extend
    keyDown: (evt) ->
      unless evt.keyCode == 9
        @_super.apply this, arguments
        return

      @get('parentView.name').$('input').focus()
      return false
