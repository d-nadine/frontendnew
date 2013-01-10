require 'radium/views/dashboard/dashboard_feed_filter_view'
require 'radium/views/feed/feed_filter_item_view'

Radium.ContactsFeedFilterView = Radium.DashboardFeedFilterView.extend
  controllerBinding: 'Radium.router.contactsController'

  content: [
    {label: 'Everything', type: 'all', addButton: false}
    {label: "Groups", type: "group", addButton: true}
    {label: "Leads", type: "lead", addButton: false}
    {label: "Prospects", type: "prospect", addButton: false}
    {label: "Opportunities", type: "opportunity", addButton: false}
    {label: "Customers", type: "customer", addButton: false}
    {label: "Dead Ends", type: "dead_end", addButton: false}
    {label: "Unassigned", type: "unassigned", addButton: false}
    {label: "Discussions", type: "discussion", addButton: true}
    {label: "No Upcoming Tasks", type: "no_tasks", addButton: false}
  ]

  # Add the notification list item after, since it isn't a loopable addButton
  itemViewClass: Radium.FeedFilterItemView
