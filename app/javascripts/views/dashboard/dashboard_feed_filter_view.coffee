require 'radium/views/feed/feed_filter_item_view'

Radium.DashboardFeedFilterView = Em.CollectionView.extend
  tagName: 'ul'
  classNames: 'nav nav-tabs nav-stacked filters'.w(),

  controllerBinding: 'Radium.router.activeFeedController'

  content: [
    {label: 'Everything', type: 'all', addButton: false}
    {label: 'Todos', type: 'todo', addButton: true}
    {label: 'Deals', type: 'deal', addButton: false}
    {label: 'Phone Calls', type: 'phone_call', addButton: false}
    {label: 'Meetings', type: 'meeting', addButton: true}
    {label: 'Contacts', type: 'contact', addButton: false}
  ]

  itemViewClass: Radium.FeedFilterItemView
