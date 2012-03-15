/**
  The base model class for any model that has a name, id, created_at and updated_at key
  @returns {Object}
*/

Radium.Person = Radium.Core.extend({
  name: DS.attr('string'),
  
  // Computed name properties
  abbrName: function() {
    var nameArray = this.get('name').split(" ");
    if (nameArray.length > 1) {
      return nameArray[0] + " " + nameArray[nameArray.length - 1].substr(0, 1) + ".";
    } else {
      return nameArray[0];
    }
    
  }.property('name'),
  firstName: function() {
    return this.get('name').split(" ")[0];
  }.property('name'),
  
  // Default hasMany groups
  deals: DS.hasMany('Radium.Deal'),
  campaigns: DS.hasMany('Radium.Campaign'),
  todos: DS.hasMany('Radium.Todo'),
  meetings: DS.hasMany('Radium.Meeting'),
  reminders: DS.hasMany('Radium.Reminder'),
  groups: DS.hasMany('Radium.Group'),
  notes: DS.hasMany('Radium.Note'),
  phoneCalls: DS.hasMany('Radium.PhoneCall', {
    key: 'phone_calls'
  }),
  messages: DS.hasMany('Radium.Message'),
  activities: DS.hasMany('Radium.Activity'),
  followers: DS.hasMany('Radium.Follower')
});