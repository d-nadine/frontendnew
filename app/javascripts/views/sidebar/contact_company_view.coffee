require 'lib/radium/company_picker'
require 'mixins/views/inline_combobox_toggle_mixin'

Radium.SidebarContactCompanyView = Radium.InlineEditorView.extend
  companyPicker: Radium.CompanyPicker.extend Radium.ComboboxSelectMixin, Radium.InlineComboboxToggleMixin,
    classNameBindings: [':field', 'isInvalid']
    placeholder: 'choose a company'
    valueBinding: 'controller.form.company'

    isInvalid: Ember.computed 'controller.isSubmitted', 'controller.form.companyName', ->
      return unless @get('controller.isSubmitted')
      value = @get('controller.form.companyName')
      !value || value.length == 0

    keyDown: (e) ->
      unless e.keyCode == 13
        @_super.apply this, arguments
        return

      value = @$('input[type=text]').val()

      @get('controller').send 'createCompany', value

      e.preventDefault()
      e.stopPropagation()
      false
