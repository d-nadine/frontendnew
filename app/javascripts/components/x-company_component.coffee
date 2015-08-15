require "mixins/controllers/attached_files_mixin"
Radium.XCompanyComponent = Ember.Component.extend Radium.AttachedFilesMixin,
  actions:
    deleteCompany: ->
      @sendAction "deleteCompany", @get('company')

      false

  classNames: ['two-column-layout']

  model: Ember.computed.oneWay 'company'

  showDeleteConfirmation: false
