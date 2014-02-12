Radium.ShowMoreComponent = Ember.Component.extend
  actions:
    showMore: ->
      alert @get('model.metadata.page')

  pagingAvailable: ( ->
    metadata = @get('model.metadata')
    @set('isVisible', false) if metadata.isLastPage
  ).observes('model.metadata')
