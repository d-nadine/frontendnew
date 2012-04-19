Radium.FormContainer = Ember.ContainerView.extend({
  childViews: []
});

Radium.FormManager = Ember.StateManager.create({
  rootElement: '#form-container',
  rootView: Radium.FormContainer,

  initialState: 'empty',

  empty: Ember.State.create({
    showForm: function(manager, context) {
      var form = Radium[context.form + 'Form'].create();
      debugger;
      manager.getPath('rootView.childViews').pushObject(form);
      manager.goToState('open');
    }
  }),

  open: Ember.ViewState.create({
    enter: function(manager) {

    },
    exit: function(manager) {

    }
  })
});