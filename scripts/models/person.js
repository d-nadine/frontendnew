/**
  The base model class for any model that has a name, id, created_at and updated_at key
  @returns {Object}
*/

define(function(require) {
  require('ember');
  require('data');
  require('./core');
  require('./deal');
  require('./campaign');
  require('./todo');
  require('./meeting');
  require('./reminder');
  require('./note');
  require('./message');
  require('./phonecall');
  require('./activity');
  
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
    deals: DS.hasMany(Radium.Deal),
    campaigns: DS.hasMany(Radium.Campaign),
    todos: DS.hasMany(Radium.Todo),
    meetings: DS.hasMany(Radium.Meeting),
    reminders: DS.hasMany(Radium.Reminder),
    notes: DS.hasMany(Radium.Note),
    phone_calls: DS.hasMany(Radium.PhoneCall),
    messages: DS.hasMany(Radium.Message),
    activities: DS.hasMany(Radium.Activity),
    followers: DS.hasMany(Radium.Follower)
  });
  
});