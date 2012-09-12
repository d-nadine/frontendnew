Radium.NestedFeed = Ember.Mixin.create
  arrangedContent: (->
    recordType = @get 'recordType'
    recordId   = @get 'recordId'

    if content = @get 'content'
      content.map (section) ->
        id = "#{section.get('id')}##{recordId}"
        Radium.store.load(recordType, id, {
          id: id
          section_id: section.get('id')
          record_id: recordId
        })
        Radium.store.find recordType, id

  ).property('content', 'content.length')

  loadFeed: (options) ->
    return unless @get 'canScroll'

    unless @_super(options)
      if options.forward
        if item = @get('firstObject')
          if date = item.get('date')
            @get('content').load Radium.FeedSection.find(after: date.toFormattedString('%Y-%m-%d'), limit: 1, type: @get('type'), id: @get('recordId'))

      else if options.back
        if item = @get('lastObject')
          if date = item.get('date')
            @get('content').load Radium.FeedSection.find(before: date.toFormattedString('%Y-%m-%d'), limit: 1, type: @get('type'), id: @get('recordId'))
