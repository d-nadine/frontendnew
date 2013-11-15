Radium.InfiniteScrollControllerMixin = Ember.Mixin.create
  actions:
    showMore: ->
      return if @get('allPagesLoaded')

      @set('isLoading', true)

      page = @get('page') + 1

      @set('page', page)

      @modelQuery().then (records) =>
        content = @get('content')

        meta = records.store.typeMapFor(@loadingType).metadata
        @set('totalRecords', meta.totalRecords)
        @set('allPagesLoaded', meta.isLastPage)

        unless records.get('length')
          @set('isLoading', false)
          if page > meta.totalPages
            @set 'allPagesLoaded', true
          return

        ids = content.map (record) -> record.get('id')

        records.toArray().forEach (record) ->
          content.pushObject(record) unless ids.contains(record.get('id'))
          ids.push record.get('id')

        @set('isLoading', false)
