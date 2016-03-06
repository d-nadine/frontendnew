import Ember from 'ember';

Radium.FocusTextareaMixin = Ember.Mixin.create({
  init: function() {
    //super.apply this, arguments
    /*if parentController = @get('controller.parentController')
      parentController.on('focusTopic', this, 'onFocusTopic') if parentController.on*/
  },
  onFocusTopic: function() {
    if(this.$('textarea')) {
      this.$('textarea').focus();
    }
  }
});
