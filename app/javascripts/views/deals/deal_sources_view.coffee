require 'lib/radium/text_combobox'
require 'lib/radium/value_validation_mixin'

Radium.DealSourcesView = Radium.TextCombobox.extend Radium.ValueValidationMixin,
  disabledBinding: 'parentView.disabled'
  classNameBindings: [
    'disabled:is-disabled'
  ]
  sourceBinding: 'controller.controllers.dealSources.dealSources'
  valueBinding: 'controller.source'
