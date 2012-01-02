define(function(require) {
  require('jquery');
  require('ember');
  
  var button = Ember.Button.extend({
    classNames: "btn primary".w(),
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
      console.log('click', this.getPath('currentSection'));
    },
    template: Ember.Handlebars.compile('Add {{ parentView.section }}')
  });
  
  return button;
});