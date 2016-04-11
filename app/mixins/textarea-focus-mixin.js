import Ember from 'ember';

Radium.FocusTextareaMixin = Ember.Mixin.create({
  init() {
    //super.apply this, arguments
    /*if parentController = @get('controller.parentController')
      parentController.on('focusTopic', this, 'onFocusTopic') if parentController.on*/
  },
  onFocusTopic() {
    if(this.$('textarea')) {
      this.$('textarea').focus();
    }
  }
});
