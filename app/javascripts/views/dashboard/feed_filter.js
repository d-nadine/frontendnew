Radium.DashboardFeedFilterView = Radium.FeedFilterView.extend({
  filterBinding: 'Radium.feedByKindController.filter',
  groupBinding: 'Radium.feedByKindController.group',
  content: [
    {label: "Everything", kind: null, addButton: false},
    {label: "Todos", kind: 'todo', addButton: true},
    {label: "Deals", kind: 'deal', addButton: true},
    {label: "Campaigns", kind: 'campaign', addButton: true},
    {label: "Phone Calls", kind: 'phone_call', addButton: false},
    {label: "Call Lists", kind: 'call_list', addButton: true},
    {label: "Meetings", kind: 'meeting', addButton: true},
    {label: "Contacts", kind: 'contact', addButton: true}
  ],
  // Add the notification list item after, since it isn't a loopable addButton
  didInsertElement: function() {
    var notificationView = Ember.View.create({
      tagName: 'li',
      notificationsBinding: 'Radium.dashboardFeedListController.size',
      click: function() {return false;},
      template: Ember.Handlebars.compile('<a href="#">Notifications <span class="badge badge-error">{{notifications}}</span></a>')
    });
    this.get('childViews').pushObject(notificationView);
  },

  itemViewClass: Radium.FeedFilterItemView
});
