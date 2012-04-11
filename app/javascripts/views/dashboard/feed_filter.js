Radium.DashboardFeedFilterView = Radium.FeedFilterView.extend({
  filterBinding: 'Radium.feedByKindController.filter',
  groupBinding: 'Radium.feedByKindController.group',
  content: [
    {label: "Everything", kind: null, addButton: false},
    {label: "Todos", kind: 'todo', addButton: true},
    {label: "Deals", kind: 'deal', addButton: true},
    {label: "Campaigns", kind: 'campaign', addButton: true},
    {label: "Phone Calls", kind: 'phone_call', addButton: true},
    {label: "Meetings", kind: 'meeting', addButton: true}
  ]
});