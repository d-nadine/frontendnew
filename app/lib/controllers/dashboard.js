Radium.dashboardController = Ember.Object.create({
  selectedUser: null,
  stats: null,

  setChartSeries: function() {
    var user = this.get('selectedUser'),
        stats = this.get('companyStats');
    if (user) {
      var data = [
        ['Leads', user.getPath('leads.length')],
        ['Prospects', user.getPath('prospects.length')],
        ['Meetings', user.getPath('meetings.length')],
        ['Call List', user.getPath('phoneCalls.length')],
        ['Pending Deals', user.getPath('pendingDeals.length')],
        ['Closed Deals', user.getPath('closedDeals.length')],
        ['Paid Deals', user.getPath('paidDeals.length')],
        ['Rejected Deals', user.getPath('rejectedDeals.length')]
      ];
      this.set('stats', data);
    } else {
      this.set('stats', stats);
    }
  }.observes(
    'selectedUser',
    'Radium.contactsController.content',
    'Radium.dealsController.content'
  ),

  /**
    Collect these stats for the dashboard chart:
    - Leads {Radium.Contact}
    - Prospects {Radium.Contact}
    - Meetings {Radium.Meeting}
    - Call List {Radium.CallList}
    - Pending Deals {Radium.Deal}
    - Closed Deals {Radium.Deal}
    - Paid Deals {Radium.Deal}
    - Rejected Deals {Radium.Deal}

    @binding {Radium.contactsController}
    @binding {Radium.dealsController}
    @return {Array}
  */
  companyStats: function() {
    var leads = Radium.contactsController.get('leads'),
        prospects = Radium.contactsController.get('prospects'),

        pendingDeals = Radium.dealsController.get('content').filterProperty('state', 'pending').get('length'),
        closedDeals = Radium.dealsController.get('content').filterProperty('state', 'closed').get('length'),
        paidDeals = Radium.dealsController.get('content').filterProperty('state', 'paid').get('length'),
        rejectedDeals = Radium.dealsController.get('content').filterProperty('state', 'rejected').get('length'),
        meetings = Radium.meetingsController.getPath('content.length'),
        callLists = Radium.callListsController.getPath('content.length');
    return [
        ['Leads', leads.get('length')],
        ['Prospects', prospects.get('length')],
        ['Meetings', meetings],
        ['Call List', callLists],
        ['Pending Deals', pendingDeals],
        ['Closed Deals', closedDeals],
        ['Paid Deals', paidDeals],
        ['Rejected Deals', rejectedDeals]
      ];
  }.property(
    'Radium.contactsController.content',
    'Radium.dealsController.content'
  ).cacheable()
});