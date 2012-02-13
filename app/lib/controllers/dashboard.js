Radium.dashboardController = Radium.feedController.create({
  content: [],
  // Filter the feed by type
  categoryFilter: 'everything',
  filterTypes: [
    Ember.Object.create({
      title: 'Everything', 
      shortname: 'everything', 
      isMain: true
    }),
    Ember.Object.create({
      title: 'Todos', 
      shortname: 'todos', 
      formViewClass: 'Todo',
      isMain: false
    }),
    Ember.Object.create({
      title: 'Meetings', 
      shortname: 'meetings', 
      formViewClass: 'Meeting',
      isMain: false
    }), 
    Ember.Object.create({
      title: 'Phone Calls', 
      shortname: 'phonecalls', 
      formViewClass: 'CallList',
      isMain: false
    }),
    Ember.Object.create({
      title: 'Deals', 
      shortname: 'deals', 
      formViewClass: 'Deal',
      isMain: false
    }),
    Ember.Object.create({
      title: 'Messages', 
      shortname: 'messages',
      formViewClass: 'Message', 
      isMain: false
    }),
    Ember.Object.create({
      title: 'Discussions', 
      shortname: 'discussions', 
      formViewClass: 'Discussion',
      isMain: false
    }), 
    Ember.Object.create({
      title: 'Activity', 
      shortname: 'Activity', 
      isMain: true
    }), 
    Ember.Object.create({
      title: 'Pipeline', 
      shortname: 'Pipeline', 
      isMain: true
    })
  ],
  statsTitle: "Statistics",
  allStats: [
        ['Leads', 10.0],
        ['Prospects', 10],
        ['Meetings', 10],
        ['Call List', 10],
        ['Pending Deals', 20],
        ['Closed Deals', 4],
        ['Paid Deals', 6],
        ['Rejected Deals', 1]
      ]
});