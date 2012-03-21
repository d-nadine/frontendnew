Radium.PageStateMixin = Ember.Mixin.create({
  form: Ember.State.extend({
    form: null,
    enter: function() {
      var formProxy = Radium.appController.get('selectedForm'),
          type = formProxy.get('form'),
          form = this.get('form') || Radium[type+'Form'].create();
      if (formProxy.get('data')) {
        form.set('data', formProxy.get('data'));
      }

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

  // Actions
  // Add any resource form in the main layout.
  addResource: function(manager, context) {
    var formProxy = Radium.FormProxy.create(context);
    Radium.appController.set('selectedForm', formProxy);
    manager.goToState('form');
  },
  // Close up the form
  closeForm: function(manager) {
    Radium.appController.set('selectedForm', null);
    manager.goToState('ready');
  }
});
