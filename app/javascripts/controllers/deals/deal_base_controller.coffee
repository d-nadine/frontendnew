Radium.DealBaseController = Radium.ObjectController.extend
  statuses: Ember.computed.alias('controllers.accountSettings.dealStates')
  pipelineStateChecklists: Ember.computed.alias('controllers.accountSettings.pipelineStateChecklists')
  newItemDescription: ''
  newItemWeight: null
  newItemFinished: true
  newItemDate: 0
  newItemKind: 'todo'
