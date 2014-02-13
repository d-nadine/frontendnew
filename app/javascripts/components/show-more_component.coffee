Radium.ShowMoreComponent = Ember.Component.extend
  actions:
    showMore: ->
      parent = @get('targetObject.parentController')
      shower = @get('targetObject')
      model = @get('model')
      metadata = @get('model.metadata')

      @set('currentPage', @get('currentPage') + 1)

      currentPage = @get('currentPage')

      if parent.get('loadedPages').contains(currentPage)
        return shower.send 'showMore'

      owner = model.get('owner')
      store = owner.store
      adapter = store.adapterForType(model.type)

      relationship = Ember.get(owner.constructor, 'relationshipsByName').get(model.name)

      url = "/#{owner.humanize().pluralize()}/#{owner.get('id')}/activities"

      self = this

      options = {
        url: url
        page: metadata.page + 1
        callback: (metadata) =>
          parent.get('loadedPages').push(currentPage)
          model.set 'isLoading', false
          shower.send 'showMore'
          if metadata.isLastPage || metadata.page >= metadata.totalPages
            self.set('isVisible', false)
      }

      model.set 'isLoading', true

      adapter.findHasMany(store, owner, relationship, options)

  isVisible: false

  didInsertElement: ->
    @_super.apply this, arguments
    if metadata = @get('model.metadata')
      @set('isVisible', metadata.totalPages > 1)

  currentPage: 1

  pagingAvailable: ( ->
    metadata = @get('model.metadata')
    @set('isVisible', metadata.totalPages > 1)
  ).observes('model.metadata.isLastPage')
