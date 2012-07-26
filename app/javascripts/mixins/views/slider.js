Radium.Slider = Ember.Mixin.create({
  slideUp: function(cb) {
    var self = this,
        callback = cb || function() {
          self.remove();
        };
    $.when(this.$().slideUp('fast')).then(callback);
  },
  didInsertElement: function() {
    this.$().hide().slideDown('fast');
    this._super();
  }
});