define('models/todo', function(require) {

  require('ember');
  require('data');
  var Radium = require('radium');
  
  Radium.Todo = Radium.Core.extend({
    kind: DS.attr('todoKind'),
    description: DS.attr('string'),
    finish_by: DS.attr('date'),
    campaign: DS.hasOne('Radium.Campaign'),
    call_list: DS.hasOne('Radium.CallList'),
    // TODO: Find out what reference refers to
    reference: null,
    contacts: DS.hasMany('Radium.Contact'),
    comments: DS.hasMany('Radium.Comment'),
    user: DS.hasOne('Radium.User'),
    /**
      Checks to see if the Deal has passed it's close by date.
      @return {Boolean}
    */
    isOverdue: function() {
      var d = new Date().getTime(),
          finishBy = new Date(this.get('finish_by')).getTime();
      return (finishBy <= d) ? true : false;
    }.property('finish_by')
  });
  
  return Radium;
});