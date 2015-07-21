require "mixins/controllers/attached_files_mixin"
Radium.XCompanyComponent = Ember.Component.extend Radium.AttachedFilesMixin,
  classNames: ['two-column-layout']

  model: Ember.computed.oneWay 'company'
