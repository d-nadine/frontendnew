Radium.ShowMoreComponent = Ember.Component.extend
  actions:
    showMore: ->
      parent = @get('targetObject.parentController')
      shower = @get('targetObject')
      model = @get('model')
      metadata = @get('model.metadata')

      @set('currentPage', @get('currentPage') + 1)

      currentPage = @get('currentPage')
      owner = model.get('owner')
      store = owner.store
      adapter = store.adapterForType(model.type)

      relationship = Ember.get(owner.constructor, 'relationshipsByName').get(model.name)

      url = "/#{owner.humanize().pluralize()}/#{owner.get('id')}/activities"

      self = this

      options = {
        url: url
        page: metadata.page + 1
        pageSize: @get('pageSize')
        callback: (metadata) ->
          parent.get('loadedPages').push(currentPage)
          model.set 'isLoading', false
          shower.send 'showMore'
          if (metadata.page * self.get('pageSize')) >= metadata.totalRecords
            self.set('isVisible', false)
      }

      model.set 'isLoading', true

      adapter.findHasMany(store, owner, relationship, options)

    setVisibility: ->
      # hacky but something weird is happening with the metadata
      # it appears that the metadata is shared with the whole type
      # and does not reset unless the model is reloaded
      if @get('currentPage') == 1
        visibility = @get('model.length') > @get('pageSize')
        @set 'isVisible', visibility
        return

      unless metadata = @get('model.metadata')
        @set 'isVisible', false
        return

      isVisible = (metadata.page * @get('pageSize')) <= metadata.totalRecords

      @set('isVisible', isVisible)

  isVisible: false
  currentPage: 1
  pageSize: 7

  didInsertElement: ->
    @_super.apply this, arguments

    @send 'setVisibility'

  pagingAvailable: Ember.observer 'model.metadata', 'model.metadata.isLastPage', ->
    @send 'setVisibility'
