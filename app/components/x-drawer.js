import Ember from 'ember';

const {
  Component
} = Ember;

export default Component.extend({
 actions: {
   closeDrawer: function() {
     const sendClose = () => {
       // FIXME: refactor to closure action
       this.sendAction('closeDrawer');
       return false;
     };

     if (this.get('_state') !== 'inDOM') {
       return sendClose();
     }

     const el = this.$();


     if (!el.length) {
       return sendClose;
     }

     el.removeClass('open');
     el.one($.support.transition.end, sendClose);
     return false;
   }
 },
  classNames: ['drawer-view'],

  _setup: Ember.on('didInsertElement', function() {
    this._super(...arguments);

    const el = this.$(),
          self = this;

    const addOverlay = () => {
      const rect = el.get(0).getBoundingClientRect();
      const overlay = $("<div class='drawer-overlay'></div>");

      overlay.css({
        position: "absolute",
        top: rect.top + $(window).scrollTop() - 10 + "px",
        left: (rect.right - 10) + "px",
        height: rect.height + 50 + "px"
      }).appendTo('body');

      overlay.on('click', function(e) {
        self.send("closeDrawer");
        e.stopPropagation();
        return e.preventDefault();
      });

      return self.set('overlay', overlay);
    };

    el.one($.support.transition.end, addOverlay);

    /*jshint -W030*/
    el.get(0).offsetWidth;

    return el.addClass('open');
  }),
  _teardown: Ember.on('willDestroyElement', function() {
    this._super.apply(this, arguments);
    let overlay;

    if (!(overlay = this.get('overlay'))) {
      return undefined;
    }

    overlay.off("click");

    return overlay.remove();
  })
});