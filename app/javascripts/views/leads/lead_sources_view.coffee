require 'lib/radium/value_validation_mixin'

Radium.LeadSourcesView = Radium.TextCombobox.extend Radium.ValueValidationMixin,
  disabledBinding: 'parentView.disabled'
  classNameBindings: [
    'disabled:is-disabled'
  ]
  sourceBinding: 'targetObject.controllers.accountSettings.leadSources'
  valueBinding: 'targetObject.source'
  placeholder: 'Where is this lead from?'
