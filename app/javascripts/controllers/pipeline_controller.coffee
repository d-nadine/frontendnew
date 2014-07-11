Radium.PipelineController = Radium.ObjectController.extend
  needs: ['accountSettings']
  dealStates: Ember.computed.alias 'controllers.accountSettings.dealStates'
  workflowStates: Ember.computed.alias 'controllers.accountSettings.workflowStates'
  workflowGroups: Ember.computed.alias 'content.workflowGroups'
  leads: Ember.computed.alias 'content.leads'
  closed: Ember.computed.alias 'content.closed'
  unpublished: Ember.computed.alias 'content.unpublished'
  lost: Ember.computed.alias 'content.lost'
  isLargeWorkflow: Ember.computed.gt('workflowGroups.length', 5)
  searchText: ""
  filterStartDate: null
  filterEndDate: null
  showPastDateRange: false
  showFutureDateRange: true
  searchTextEmpty: Ember.computed.empty "searchText"
  isTextFiltering: Ember.computed.not "searchTextEmpty"
  isDateFiltering: Ember.computed.and "filterStartDate", "filterEndDate"
  isBothFiltering: Ember.computed.and "isDateFiltering", "isTextFiltering"
