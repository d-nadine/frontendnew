Radium.ShowMetalessMoreMixin = Ember.Mixin.create
  actions:
    showMore: ->
      return if @get('allPagesLoaded')
      return if @get('isContentLoading')

      @set 'isContentLoading', true

      page = (@get('page') || 1) + 1
      pageSize = @get('pageSize')

      @set('page', page)

      @modelQuery(page, pageSize).then (records) =>
        unless records.get('length')
          @set('isContentLoading', false)
          @set('allPagesLoaded', true)
          return

        return unless content = @get('content')

        ids = content.map (record) -> record.get('id')

        records.toArray().forEach (record) ->
          content.pushObject(record) unless ids.contains(record.get('id'))
          ids.push record.get('id')

        @set 'isContentLoading', false

        return if @get('allPagesLoaded') || !minimumPageLoaded = @get('minimumPageLoaded')

        if minimumPageLoaded && page < minimumPageLoaded
          @send "showMore"

    reset: ->
      @set('page', 1)
      @set('allPagesLoaded', false)
      @set('isLoading', false)

  modelQuery: (page, pageSize) ->
    throw new Error("You must provide a modelQuery method which accepts page and pageSize arguments.")
