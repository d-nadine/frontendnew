Radium.PipelineController = Em.ArrayController.extend
  negotiatingGroups: Ember.computed.alias 'content.negotiatingGroups'
  leads: Ember.computed.alias 'content.leads'
  closed: Ember.computed.alias 'content.closed'
  lost: Ember.computed.alias 'content.lost'
