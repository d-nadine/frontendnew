define(function(require) {
  
  var Radium = require('radium');
  require('models/deal');

  Radium.Deal.FIXTURES = [
    {
      id: 31,
      state: 'pending',
      created_at: "2011-12-15T09:37:23Z",
      updated_at: "2011-12-15T09:37:23Z",
      description: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.",
      close_by: "2011-12-22T09:37:23Z",
      line_items: [
        {
          id: 34,
          name: "Radium",
          quantity: 1,
          price: "1000.0",
          currency: "USD",
          product: null
        },
        {
          id: 33,
          name: "Radium",
          quantity: 1,
          price: "1000.0",
          currency: "USD",
          product: null
        },
        {
          id: 32,
          name: "Radium",
          quantity: 1,
          price: "1000.0",
          currency: "USD",
          product: null
        }
      ],
      contact_id: 151,
      user_id: 460,
      todos: [],
      comments: [],
      products: [],
      activities: []
    }
  ];
});