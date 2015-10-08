require "mixins/controllers/attached_files_mixin"
require "mixins/common_modals"

Radium.XCompanyComponent = Ember.Component.extend Radium.AttachedFilesMixin,
  Radium.CommonModals,

  actions:
    deleteCompany: ->
      @sendAction "deleteCompany", @get('company')

      @EventBus.publish 'closeDrawers'

      false

  classNames: ['two-column-layout']

  model: Ember.computed.oneWay 'company'

  showDeleteConfirmation: false
