var todoKinds = ["call", "general", "support"],
    limit = 100;

Radium.Activity.FIXTURES = [];

for (var i = 0; i < limit; i++) {
  Radium.Activity.FIXTURES.push(
  {
    id: i+1,
    created_at: Ember.DateTime.create({
      day: new Date().getDate() - i,
      hour: Math.floor(Math.random() * 12),
      minute: Math.floor(Math.random() * 59)
    }).toISO8601(),
    updated_at: Ember.DateTime.create({
      day: new Date().getDate() - i,
      hour: Math.floor(Math.random() * 12),
      minute: Math.floor(Math.random() * 59)
    }).toISO8601(),
    tags: ["todo","assigned"],
    timestamp: Ember.DateTime.create({
      day: new Date().getDate() - i,
      hour: Math.floor(Math.random() * 12),
      minute: Math.floor(Math.random() * 59)
    }).toISO8601(),
    // owner: {
    //   id: Math.floor(Math.random() * 10000),
    //   user: {
    //     id: 12312,
    //     created_at: "2011-12-28T14:26:27Z",
    //     updated_at: "2011-12-28T14:26:27Z",
    //     name: "Omar Little",
    //     email: "irobsdrugdealers@hotmail.com",
    //     phone: "+1410333-3321",
    //     is_public: true,
    //     contacts: [33, 44],
    //     deals: [65, 11],
    //     campaigns: [],
    //     following: [],
    //     followers: [],
    //     todos: [],
    //     meetings: [],
    //     reminders: [],
    //     notes: [],
    //     phone_calls: [],
    //     ims: [],
    //     emails: [],
    //     sms: [],
    //     activities: [],
    //     account: 1
    //   }
    // },
    reference: {
      id: Math.floor(Math.random() * 10000),
      todo: {
        id: i+1*1000,
        created_at: "2011-12-28T14:26:27Z",
        updated_at: Ember.DateTime.create({
          day: i+1,
          hour: Math.floor(Math.random() * 24),
          minute: Math.floor(Math.random() * 59)
        }).toISO8601(),
        kind: todoKinds[Math.floor(Math.random() * todoKinds.length)],
        description: "Finish programming radium",
        finish_by: Ember.DateTime.create({
          day: i+1,
          hour: Math.floor(Math.random() * 24),
          minute: Math.floor(Math.random() * 59)
        }).toISO8601(),
        finished: false,
        contacts: [33, 44, 55],
        comments: [12],
        activities: [51, 52],
        user: 45,
        reference: null
      }
    }
  }
)
}