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

      @get('parentView.company').$('input').focus()
      return false

  companyPicker: Radium.ContactCompanyPicker.extend Radium.ComboboxSelectMixin,
    valueBinding: 'controller.form.company'
    companyNameBinding: 'controller.form.companyName'
    setValue: ->
      @_super.apply this, arguments
      Ember.run.next =>
        @get('parentView').send 'toggleEditor'
