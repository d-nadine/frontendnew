define('views/filter_list', function(require) {
  
  require('ember');
  var Radium = require('radium');
  require('controllers/resources');
  
  var template = require('text!templates/filter_list.handlebars');
  
  Radium.ActivityFilterList = Ember.CollectionView.extend({
    tagName: 'ul',
    classNames: 'nav nav-tabs nav-stacked'.w(),
    contentBinding: 'Radium.resourcesController.content',
    itemViewClass: Ember.View.extend({
      categoryFilterBinding: 'Radium.feedController.categoryFilter',
      isEnabled: function() {
        return (this.get('categoryFilter') == this.getPath('content.shortname')) ? true : false;
      }.property('categoryFilter').cacheable(),
      classNameBindings: ['isEnabled:active'],
      template: Ember.Handlebars.compile(template),
      changeFilter: function(event) {
        event.preventDefault();
        var type = this.getPath('content.shortname');
        Radium.feedController.set('categoryFilter', type);
        return false;
      }
    })
  });
  
  return Radium;
});