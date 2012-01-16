define('models/todo', function(require) {
  require('ember');
  require('data');
  var Radium = require('radium');
  require('./core');
  
  Radium.Todo = Radium.Core.extend({
    kind: DS.attr('string'),
    description: DS.attr('string'),
    finish_by: DS.attr('date'),
    campaign: DS.hasOne('Radium.Campaign'),
    call_list: DS.hasOne('Radium.CallList'),
    // TODO: Find out what reference refers to
    reference: null,
    contacts: DS.hasMany('Radium.Contact'),
    comments: DS.hasMany('Radium.Comment'),
    user: DS.hasOne('Radium.User')
  });
  
  return Radium;
});