define('fixtures/activities', function(require) {

  var Radium = require('radium');
  require('models/activity');

  Radium.Activity.FIXTURES = [];

  for (var i = 0; i < 100; i++) {
    Radium.Activity.FIXTURES.push(
    {
      id: i+1,
      created_at: "2012-12-28T14:26:27Z",
      updated_at: "2011-12-28T14:26:27Z",
      tags: ["tags", "describing", "what", "action", "happened"],
      timestamp: Ember.DateTime.create({day: i+1}).toISO8601(),
      owner: {
        user: {
          id: 46,
          created_at: "2011-12-28T14:26:27Z",
          updated_at: "2011-12-28T14:26:27Z",
          name: "Omar Little",
          email: "irobsdrugsdealers@hotmail.com",
          phone: "+1410333-3321",
          is_public: true,
          contacts: [33, 44],
          deals: [65, 11],
          campaigns: [],
          following: [],
          followers: [],
          todos: [],
          meetings: [],
          reminders: [],
          notes: [],
          phone_calls: [],
          ims: [],
          emails: [],
          sms: [],
          activities: [],
          account: 1
        }
      },
      reference: {
        todo: {
          id: 3,
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
      }
    }
  )
  }
  
  return Radium;
});