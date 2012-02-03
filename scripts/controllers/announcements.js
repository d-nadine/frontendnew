define('controllers/announcements', function(require) {
  var Radium = require('radium');

  Radium.announcementsController = Ember.ArrayProxy.create({
    content: []
  });

  return Radium;
});