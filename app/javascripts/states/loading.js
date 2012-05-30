Radium.LoadingManager = Ember.StateManager.create({
  start: Ember.ViewState.create({
    view: Ember.View.extend({
      elementId: 'mini-loader',
      classNames: 'alert alert-block'.w(),
      slideUp: function() {
        this.$().animate({
          bottom: -20
        }, 500);
      },
      slideDown: function() {
        this.$().animate({
          bottom: -70
        }, 500);
      },
      template: Ember.Handlebars.compile('<h4 class="alert-heading">Loading &hellip;</h4>')
    }),

    show: function(manager, context) {
      var view = this.get('view');
      view.slideUp();
    },

    hide: function(manager, context) {
      var view = this.get('view');
      view.slideDown();
    }
  })
});