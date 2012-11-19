Radium.DashboardFeedFilterView = Em.CollectionView.extend
  tagName: 'ul'
  classNames: 'nav nav-tabs nav-stacked filters'.w(),

  controllerBinding: 'Radium.router.feedController'

  content: [
    {label: 'Everything', type: 'all', addButton: false}
    {label: 'Todos', type: 'todo', addButton: true}
    {label: 'Deals', type: 'deal', addButton: false}
    {label: 'Campaigns', type: 'campaign', addButton: false}
    {label: 'Phone Calls', type: 'phone_call', addButton: false}
    {label: 'Call Lists', type: 'call_list', addButton: false}
    {label: 'Meetings', type: 'meeting', addButton: true}
    {label: 'Contacts', type: 'contact', addButton: false}
  ]

  itemViewClass: Radium.FeedFilterItemView
