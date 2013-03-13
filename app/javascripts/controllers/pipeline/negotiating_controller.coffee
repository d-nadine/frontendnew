Radium.PipelineNegotiatingController = Ember.ObjectController.extend
  title: 'Negotiating'

  groups: ( ->
    return [] unless @get('negotiatingGroups.length')

    Ember.ArrayProxy.create
      content: @get('negotiatingGroups')
  ).property('negotiatingGroups')
