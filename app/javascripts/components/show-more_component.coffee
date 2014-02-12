Radium.ShowMoreComponent = Ember.Component.extend
  actions:
    showMore: ->
      model = @get('model')
      parent = model.get('owner')
      store = parent.store
      adapter = store.adapterForType(model.type)
      metadata = @get('model.metadata')

      relationship = Ember.get(parent.constructor, 'relationshipsByName').get(model.name)

      url = "/#{parent.humanize().pluralize()}/#{parent.get('id')}/activities"

      options = {
        url: url
        page: metadata.page + 1
        callback: (metadata) =>
          @set('isVisible', false) if metadata.isLastPage
          model.set 'isLoading', false
      }

      model.set 'isLoading', true

      adapter.findHasMany(store, parent, relationship, options)

  pagingAvailable: ( ->
    metadata = @get('model.metadata')
    @set('isVisible', false) if metadata.isLastPage
  ).observes('model.metadata.isLastPage')
