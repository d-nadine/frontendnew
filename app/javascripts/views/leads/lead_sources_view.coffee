Radium.LeadSourcesView = Radium.TextCombobox.extend Radium.ValueValidationMixin,
  disabledBinding: 'parentView.disabled'
  classNameBindings: [
    'disabled:is-disabled'
  ]
  sourceBinding: 'controller.controllers.leadSources.leadSources'
  valueBinding: 'controller.source'
  placeholder: 'Where is this lead from?'
