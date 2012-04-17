Radium.feedListController = Ember.ArrayProxy.create(Radium.CFDimension, {
  content: [],
  contentWillChange: function() {
    console.log('1', arguments);
    this._super();
  }.observesBefore('content.@each'),
  contentDidChange: function() {
    console.log('2', arguments);
    this._super();
  }.observes('content.@each'),
});