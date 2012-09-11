Radium.ContactsFeedController = Radium.FeedController.extend
  arrangedContent: (->
    contact_id = @get('contact_id')

    if content = @get('content')
      content.map (section) ->
        id = "#{section.get('id')}##{contact_id}"
        Radium.store.load(Radium.ContactFeedSection, id, {
          id: id
          section_id: section.get('id')
          contact_id: contact_id
        })
        Radium.store.find Radium.ContactFeedSection, id
  ).property('content', 'content.length')

  loadFeed: (options) ->
    return unless @get 'canScroll'

    unless @_super(options)
      if options.forward
        if item = @get('firstObject')
          if date = item.get('date')
            @get('content').load Radium.FeedSection.find(after: date.toFormattedString('%Y-%m-%d'), limit: 1, type: 'contact', id: @get('contact_id'))

      else if options.back
        if item = @get('lastObject')
          if date = item.get('date')
            @get('content').load Radium.FeedSection.find(before: date.toFormattedString('%Y-%m-%d'), limit: 1, type: 'contact', id: @get('contact_id'))
