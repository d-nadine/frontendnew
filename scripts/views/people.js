define(function(require) {
  var Radium = require('core/radium'),
      peopleController = require('controllers/people'),
      testTmpl = require('text!templates/people.html');

  Radium.TestCollectionView = Ember.CollectionView.extend({
    tagName: 'ul',
    contentBinding: 'Radium.peopleController',
    itemViewClass: Ember.View.extend({
      template: Ember.Handlebars.compile(testTmpl),
      click: function() {
        console.log(this.getPath('content.fullName'));
      }
    }),
  });
  
  return Radium.TestCollectionView;
});