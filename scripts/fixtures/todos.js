define(function(require) {
  
  var Radium = require('radium');
  require('models/todo');

  Radium.Todo.FIXTURES = [
    {
      id: 1001,
      created_at: "2011-12-28T14:26:27Z",
      updated_at: "2011-12-28T14:26:27Z",
      kind: "general",
      description: "Finish programming radium",
      finish_by: "2012-01-04T14:26:22Z",
      contacts: [33, 44, 55],
      comments: [],
      activities: [51, 52],
      user: 45,
      reference: null
    },
    {
      id: 1002,
      created_at: "2011-12-28T14:26:27Z",
      updated_at: "2011-12-28T14:26:27Z",
      kind: "pending",
      description: "Finish programming radium",
      finish_by: "2012-01-04T14:26:22Z",
      contacts: [33, 44, 55],
      comments: [],
      activities: [51, 52],
      user: 45,
      reference: null
    },
    {
      id: 1003,
      created_at: "2011-12-28T14:26:27Z",
      updated_at: "2011-12-28T14:26:27Z",
      kind: "general",
      description: "Finish programming radium",
      finish_by: "2012-01-04T14:26:22Z",
      contacts: [33, 44, 55],
      comments: [],
      activities: [51, 52],
      user: 45,
      reference: null
    },
    {
      id: 1004,
      created_at: "2011-12-28T14:26:27Z",
      updated_at: "2011-12-28T14:26:27Z",
      kind: "general",
      description: "Finish programming radium",
      finish_by: "2012-01-04T14:26:22Z",
      contacts: [33, 44, 55],
      comments: [],
      activities: [51, 52],
      user: 45,
      reference: null
    },
    {
      id: 1005,
      created_at: "2011-12-28T14:26:27Z",
      updated_at: "2011-12-28T14:26:27Z",
      kind: "general",
      description: "Finish programming radium",
      finish_by: "2012-01-04T14:26:22Z",
      contacts: [33, 44, 55],
      comments: [],
      activities: [51, 52],
      user: 45,
      reference: null
    },
    {
      id: 1006,
      created_at: "2011-12-28T14:26:27Z",
      updated_at: "2011-12-28T14:26:27Z",
      kind: "general",
      description: "Finish programming radium",
      finish_by: "2012-01-04T14:26:22Z",
      contacts: [33, 44, 55],
      comments: [],
      activities: [51, 52],
      user: 45,
      reference: null
    }
  ];
});