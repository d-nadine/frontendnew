require 'lib/radium/value_validation_mixin'

Radium.SettingsBillingView = Radium.View.extend
  organisationView: Ember.TextField.extend Radium.ValueValidationMixin,
    valueBinding: 'controller.organisation'

  billingInfoView: Ember.TextField.extend Radium.ValueValidationMixin,
    valueBinding: 'controller.billingEmail'
