Radium.Deal.FIXTURES = [
  {
    id: 1231,
    state: 'rejected',
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
    close_by: Ember.DateTime.create({
      day: new Date().getDate() + 10,
      hour: Math.floor(Math.random() * 12),
      minute: Math.floor(Math.random() * 59)
    }).toISO8601(),
    line_items: [
      {
        id: 34,
        name: "Radium",
        quantity: 1,
        price: "111000.0",
        currency: "USD",
        product: null
      },
      {
        id: 3133,
        name: "Radium",
        quantity: 1,
        price: "13000.50",
        currency: "USD",
        product: null
      }
    ],
    contact: 104,
    user: 2,
    todos: [],
    comments: [],
    products: [],
    activities: []
  },
  {
    id: 131313,
    state: 'closed',
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
    close_by: Ember.DateTime.create({
      day: new Date().getDate() - 10,
      hour: Math.floor(Math.random() * 12),
      minute: Math.floor(Math.random() * 59)
    }).toISO8601(),
    line_items: [
      {
        id: 41414,
        name: "Radium",
        quantity: 1,
        price: "1000.0",
        currency: "USD",
        product: null
      },
      {
        id: 2132321,
        name: "Radium",
        quantity: 1,
        price: "1000.50",
        currency: "USD",
        product: null
      },
      {
        id: 123134,
        name: "Radium",
        quantity: 1,
        price: "1220.0",
        currency: "USD",
        product: null
      }
    ],
    contact: 102,
    user: 4,
    todos: [],
    comments: [],
    products: [],
    activities: []
  },
  {
    id: 31444,
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
    close_by: Ember.DateTime.create({
      day: new Date().getDate() - 10,
      hour: Math.floor(Math.random() * 12),
      minute: Math.floor(Math.random() * 59)
    }).toISO8601(),
    line_items: [
      {
        id: 4141412,
        name: "Radium",
        quantity: 1,
        price: "1000.0",
        currency: "USD",
        product: null
      },
      {
        id: 213213321,
        name: "Radium",
        quantity: 1,
        price: "1000.50",
        currency: "USD",
        product: null
      },
      {
        id: 123112313234,
        name: "Radium",
        quantity: 1,
        price: "1220.0",
        currency: "USD",
        product: null
      }
    ],
    contact: 102,
    user: 4,
    todos: [],
    comments: [],
    products: [],
    activities: []
  },
  {
    id: 1313131122,
    state: 'rejected',
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
    close_by: Ember.DateTime.create({
      day: new Date().getDate() + 10,
      hour: Math.floor(Math.random() * 12),
      minute: Math.floor(Math.random() * 59)
    }).toISO8601(),
    line_items: [
      {
        id: 41412314,
        name: "Radium",
        quantity: 1,
        price: "1000.0",
        currency: "USD",
        product: null
      },
      {
        id: 21323231331,
        name: "Radium",
        quantity: 1,
        price: "1000.50",
        currency: "USD",
        product: null
      },
      {
        id: 123134144,
        name: "Radium",
        quantity: 1,
        price: "1220.0",
        currency: "USD",
        product: null
      }
    ],
    contact: 102,
    user: 4,
    todos: [],
    comments: [],
    products: [],
    activities: []
  }
];