define(function(require) {
  var testTmpl = require('text!templates/people.html'),
      view;

  view = Ember.CollectionView.extend({
    tagName: 'ul',
    contentBinding: 'Radium.peopleController',
    itemViewClass: Ember.View.extend({
      template: Ember.Handlebars.compile(testTmpl),
      click: function() {
        console.log(this.getPath('content.fullName'));
      }
    }),
  });
  
  return view.create();
});