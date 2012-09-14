Radium.CalendarFeedView = Radium.FeedView.extend Radium.InfiniteScroller,
  empty: (->
    # TODO: since @each does not properly work when nested a few times, it would be
    #       better to add observers on content that would set empty to true/false,
    #       but for now I'm just disabling it for contacts
    false
  ).property()
