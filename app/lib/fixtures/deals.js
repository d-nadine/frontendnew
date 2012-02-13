Radium.Deal.FIXTURES = [
  {
    id: 1231,
    state: 'pending',
    created_at: Ember.DateTime.create({
      day: new Date().getDate(),
      hour: Math.floor(Math.random() * 12),
      minute: Math.floor(Math.random() * 59)
    }).toISO8601(),
    updated_at: Ember.DateTime.create({
      day: new Date().getDate(),
      hour: Math.floor(Math.random() * 12),
      minute: Math.floor(Math.random() * 59)
    }).toISO8601(),
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