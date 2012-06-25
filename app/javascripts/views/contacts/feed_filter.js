Radium.ContactsFeedFilterView = Radium.FeedFilterView.extend({
  filterBinding: 'Radium.selectedContactsController.selectedFilter',
  content: [
    {label: "Everything", kind: null, addButton: false},
    {label: "Contacts", kind: 'contact', addButton: true},
    {label: "Groups", kind: 'group', addButton: true},
    {label: "Leads", kind: 'lead', addButton: false},
    {label: "Prospects", kind: 'prospect', addButton: false},
    {label: "Opportunities", kind: 'opportunity', addButton: false},
    {label: "Customers", kind: 'customer', addButton: false},
    {label: "Dead Ends", kind: 'dead_end', addButton: false},
    {label: "Unassigned", kind: 'unassigned', addButton: false},
    {label: "Discussions", kind: 'note', addButton: true},
    {label: "No Upcoming Tasks", kind: 'no_tasks', addButton: false}
  ],
  // Add the notification list item after, since it isn't a loopable addButton
  itemViewClass: Radium.FeedFilterItemView
});
