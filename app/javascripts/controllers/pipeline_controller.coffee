Radium.PipelineController = Radium.ArrayController.extend
  needs: ['accountSettings']
  negotiatingStates: Ember.computed.alias 'controllers.accountSettings.negotiatingStates'
  negotiatingGroups: Ember.computed.alias 'content.negotiatingGroups'
  leads: Ember.computed.alias 'content.leads'
  closed: Ember.computed.alias 'content.closed'
  unpublished: Ember.computed.alias 'content.unpublished'
  lost: Ember.computed.alias 'content.lost'
