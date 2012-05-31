Radium.TopbarController = Ember.Object.extend({
  init: function(){
    this.set('view', Radium.TopbarView.create());
    this.get('view').appendTo('#topbar');
  }
});
