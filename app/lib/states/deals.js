Radium.DealsState = Ember.ViewState.extend({
  initialState: 'load',
  view: Radium.DealPageView.create(),
  load: Ember.State.create({
    enter: function() {
      var deals = Radium.store.findAll(Radium.Deal);
      Radium.dealsController.set('content', deals);
    }
  }),
  form: Ember.State.create({
    form: null,
    formType: 'Todo',
    enter: function() {
      var type = this.get('formType');
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

  //Actions
  closeForm: function(manager) {
    manager.goToState('ready');
  },
  addResource: function(manager, context) {
    Radium.App.setPath('loggedIn.deals.form.formType', context);
    manager.goToState('form');
  }
});