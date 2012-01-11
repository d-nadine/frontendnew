define('models/phonecall', function(require) {
  
  require('ember');
  require('data');
  var Radium = require('radium');
  require('./core');
  
  Radium.PhoneCall = Radium.Core.extend({
    // FIXME: Add validation, can only be one of the following: not_interested, unanswered, follow_up_required
    outcome: DS.attr('string'),
    duration: DS.attr('integer'),
    kind: DS.attr('string'),
    dialed_at: DS.attr('date'),
    // TODO: Figure out how best to implement these at the model level.
    to: DS.hasMany(Radium.Contact),
    from: DS.hasMany(Radium.User),
    contacts: DS.hasMany(Radium.Contact),
    users: DS.hasMany(Radium.User),
    comments: DS.hasMany(Radium.Comment),
    todos: DS.hasMany(Radium.Todo)
    
  });
  
  return Radium;
});