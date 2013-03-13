Radium.PipelineNegotiatingController = Ember.ArrayController.extend
  title: 'Negotiating'

  groups: ( ->
    return [] unless @get('model.negotiatingGroups.length')

    Ember.ArrayProxy.create
      content: @get('model.negotiatingGroups')
  ).property('model.negotiatingGroups')
