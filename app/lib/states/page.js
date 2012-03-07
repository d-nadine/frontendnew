Radium.PageStateMixin = Ember.Mixin.create({
  form: Ember.State.extend({
    form: null,
    formType: 'Todo',
    enter: function() {
      var type = Radium.appController.get('selectedForm');
      var form = this.get('form') || Radium[type+'FormView'].create();
      form.appendTo('#form-container');
      this.set('form', form);
      this.setPath('parentState.isFormAddView', true);
    },
    exit: function() {
      this.get('form').destroy();
      this.set('form', null);
      this.setPath('parentState.isFormAddView', false);
    }
  }),

  ready: Ember.State.create(),

  // Actions
  // Add any resource form in the main layout.
  addResource: function(manager, context) {
    Radium.appController.set('selectedForm', context);
    manager.goToState('form');
  },
  // Close up the form
  closeForm: function(manager) {
    Radium.appController.set('selectedForm', null);
    manager.goToState('ready');
  }
});
