require 'radium/controllers/feed_controller'

Radium.CalendarFeedController = Radium.FeedController.extend
  typeFilters: ['deal', 'todo', 'meeting']

  disableClusters: true
