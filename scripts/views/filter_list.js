define('views/filter_list', function(require) {
  
  require('ember');
  var Radium = require('radium');
  require('controllers/resources');
  
  var template = require('text!templates/filter_list.handlebars');
  
  Radium.ActivityFilterList = Ember.CollectionView.extend({
    contentBinding: 'Radium.resourcesController.content',
    itemViewClass: Ember.View.extend({
      // currentFilterBinding: 'Radium.activityStreamController.currentFilter',
      // isEnabled: function() {
      //   return (this.get('currentFilter') == this.get('content').get('model')) ? true : false;
      // }.property('currentFilter').cacheable(),
      // classNameBindings: ['isEnabled:enabled'],
      template: Ember.Handlebars.compile(template),
      click: function() {
        var type = this.get('content').get('model');
        console.log(type);
        // Radium.activityStreamController.set('currentFilter', type);
      }
    })
  });
  
  return Radium;
});