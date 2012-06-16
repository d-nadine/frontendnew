Radium.LoadingManager = Ember.StateManager.create({
  start: Ember.ViewState.create({
    view: Ember.View.extend({
      elementId: 'mini-loader',
      classNames: 'alert alert-block'.w(),
      didInsertElement: function() {
        this.$().hide();
      },
      show: function(dir) {
        var fromTop = {top: 40},
            fromBottom = {bottom: -20},
            fromTopLayout = {bottom: 'auto', top: 0},
            fromBottomLayout = {bottom: -70, top: 'auto'},
            settings = (dir > -1) ? fromTop : fromBottom,
            layout = (dir > -1) ? fromTopLayout : fromBottomLayout;

        this.set('direction', dir);

        this.$()
          .css(layout)
          .show()
          .animate(settings, 500);
      },
      hide: function(dir) {
        var dir = this.get('direction') || dir,
            fromTop = {top:-40},
            fromBottom = {bottom: -70},
            settings = (dir > -1) ? fromTop : fromBottom;

        this.$()
          .animate(settings, 500, function() {
            $(this).hide();
          });
      },
      template: Ember.Handlebars.compile('<h4 class="alert-heading">Loading &hellip;</h4>')
    }),

    show: function(manager, context) {
      var view = this.get('view');

      view.show(context.direction);
    },

    hide: function(manager, context) {
      var view = this.get('view');
      view.hide();
    }
  })
});