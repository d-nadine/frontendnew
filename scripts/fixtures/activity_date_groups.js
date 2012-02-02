define('fixtures/activity_date_groups', function(require) {

  var Radium = require('radium');
  require('models/activity_date_group');

  Radium.ActivityDateGroup.FIXTURES = [
  {}
    // {
    //   id: 2012,
    //   type: 'year',
    //   date: '2012',
    //   items: [1001, 1002, 1003, 1004, 1005],
    //   todos: [1001, 1002, 1003, 1004, 1005]
    // },
    // {
    //   id: '2012-1',
    //   type: 'quarter',
    //   date: '2012-Q1',
    //   items: [1001, 1002, 1003, 1004, 1005],
    //   todos: [1001, 1002, 1003, 1004, 1005]
    // },
    // {
    //   id: '2012-01',
    //   type: 'month',
    //   date: '2012-01',
    //   items: [1001, 1002, 1003, 1004, 1005],
    //   todos: [1001, 1002, 1003, 1004, 1005]
    // },
    // {
    //   id: '2012-01-01',
    //   type: 'week',
    //   date: '2012-01',
    //   items: [1001, 1002, 1003, 1004, 1005],
    //   todos: [1001, 1002, 1003, 1004, 1005]
    // },
    // {
    //   id: '2012-01-02',
    //   type: 'day',
    //   date: '2012-01-02',
    //   items: [1004, 1005],
    //   todos: [1004, 1005]
    // },
    // {
    //   id: '2012-01-10',
    //   type: 'day',
    //   date: '2012-01-10',
    //   items: [],
    //   todos: []
    // },
    // {
    //   id: '2012-01-15',
    //   type: 'day',
    //   date: '2012-01-15',
    //   items: [1003],
    //   todos: [1003]
    // },
    // {
    //   id: '2012-01-20',
    //   type: 'day',
    //   date: '2012-01-20',
    //   items: [1002],
    //   todos: [1002]
    // },
    // {
    //   id: '2012-02-01',
    //   type: 'day',
    //   date: '2012-02-03',
    //   items: [1001],
    //   todos: [1001]
    // }
  ];
  
  return Radium;
});