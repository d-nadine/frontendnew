require 'lib/radium/combobox'
require 'lib/radium/text_combobox'
require 'lib/radium/user_picker'
require 'views/contact/contact_view_mixin'
require 'lib/radium/contact_company_picker'
require 'lib/radium/tag_autocomplete'
requireAll /views\/sidebar/

Radium.ContactSidebarView = Radium.View.extend Radium.ContactViewMixin,
  classNames: ['sidebar-panel-bordered']

  showExtraContactDetail: ->
    @$('.additional-detail').slideToggle('medium')
    @$('#existingToggle').toggleClass('icon-arrow-up icon-arrow-down')
