define(function(require) {
  require('ember');
  
  var button = Ember.Button.extend({
    classNames: "btn primary pull-right".w(),
    isVisible: function() {
      var section = this.getPath('parentView.currentSection');
      if (!section || section === 'settings') {
        return false;
      } else {
        return true;
      }
      return false;
    }.property('parentView.currentSection'),
    click: function() {
      // TODO: Add action for creating new action bound by current section here
    },
    template: Ember.Handlebars.compile('Add {{ parentView.section }}')
  });
  
  return button;
});