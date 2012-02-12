Radium.dashboardController = Radium.feedController.create({
  content: [],
  // Filter the feed by type
  categoryFilter: 'everything',
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