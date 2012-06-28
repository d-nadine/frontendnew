Radium.PersistentContainerView = Ember.ContainerView.extend({
  // _currentViewWillChange: Ember.beforeObserver(function() {
  //   var childViews = this.get('childViews'),
  //       currentView = this.get('currentView');

  //   if (currentView) {
  //     //childViews.removeObject(currentView);
  //   }
  // }, 'currentView'),

  // _currentViewDidChange: Ember.observer(function() {
  //   var childViews = this.get('childViews'),
  //       currentView = this.get('currentView');

  //   if (currentView) {
  //       currentView.set('isVisible', true);
  //       childViews.filter(function(view) {
  //           return view != currentView;
  //       }).setEach('isVisible', false);
  //       if (childViews.indexOf(currentView) === -1) {
  //           childViews.pushObject(currentView);
  //       }
  //   }
  // }, 'currentView')
});
