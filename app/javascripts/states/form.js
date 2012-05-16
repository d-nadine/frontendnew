Radium.FormContainer = Ember.ContainerView.create({
  didInsertElement: function() {
    this.$().hide().slideDown(300);
  }
});

Radium.FormManager = Ember.StateManager.create({
  enableLogging: true,
  // rootElement: '#form-container',
  rootView: Radium.FormContainer,

  initialState: 'empty',

  empty: Ember.State.create({
    showForm: function(manager, context) {
      var form = Radium[context.form + 'Form'].create({
                  params: context,
                  formType: context.form
                });
      if (Radium.FormContainer.get('state') !== 'inDOM') {
        Radium.FormContainer.appendTo('#form-container');
      }
      manager.getPath('rootView.childViews').pushObject(form);
      manager.set('formName', context.form);
      manager.goToState('open');
    },
    closeForm: Ember.K()
  }),

  open: Ember.State.create({

    closeForm: function(manager, context) {
      var currentForm = manager.getPath('rootView.childViews.firstObject');
      manager.getPath('rootView.childViews').removeObject(currentForm);
      manager.set('formName', null);
      manager.goToState('empty');
      manager.get('rootView').remove();
    },
    showForm: function(manager, context) {
      var form = Radium[context.form + 'Form'].create({
                    params: context,
                    formType: context.form
                  }),
          container = manager.getPath('rootView.childViews');
      if (context.form !== manager.get('formName')) {
        container.removeAt(0);
        container.pushObject(form);
      } else {
        manager.send('closeForm');
      }
    }
  })
});