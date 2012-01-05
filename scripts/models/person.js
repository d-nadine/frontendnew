/**
  The base model class for any model that has a name, id, created_at and updated_at key
  @returns {Object}
*/

define(function(require) {
  require('ember');
  require('data');
  require('models/deal');
  
  var Person = DS.Model.extend({
    name: DS.attr('string'),
    created_at: DS.attr('string'),
    updated_at: DS.attr('string'),
    
    // Computed name properties
    abbrName: function() {
      var nameArr = this.get('name').split(" ");
      return nameArr[0] + " " + nameArr[nameArr.length - 1].substr(0, 1) + ".";
    }.property('name'),
    firstName: function() {
      return this.get('name').split(" ")[0];
    }.property('name'),
    
    // Default ToMany groups
    deals: DS.toMany(Radium.Deal),
    campaigns: DS.toMany(Radium.Campaign),
    todos: DS.toMany(Radium.Todo),
    meetings: DS.toMany(Radium.Meeting),
    reminders: DS.toMany(Radium.Reminder),
    notes: DS.toMany(Radium.Note),
    phone_calls: DS.toMany(Radium.PhoneCall),
    messages: DS.toMany(Radium.Message),
    activities: DS.toMany(Radium.Activity),
    followers: DS.toMany(Radium.User)
  });
  
  return Person;
  
});