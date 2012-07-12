Radium.FormContainer = Ember.ContainerView.create({
  classNames: ['create-form'],
  didInsertElement: function() {
    this.$().hide().slideDown(300);
  },
  adjustPosition: function(position) {
    var viewportWidth = $(window).width(),
        viewportOffset = (viewportWidth - position.left),
        layout = {top: position.top - 20};

    if (viewportOffset < 700) {
      layout.right = viewportOffset;
      layout.left = 'auto';
    } else {
      layout.left = position.left + 20;
      layout.right = 'auto';
    }

    this.$().css(layout);
  }
}).append();

Radium.FormManager = Ember.StateManager.extend({
  enableLogging: true,
  // rootElement: '#form-container',
  rootView: Radium.FormContainer,

  initialState: 'empty',

  empty: Ember.State.create({
    showForm: function(manager, context) {
      var rootView = manager.get('rootView')
          form = Radium[context.form + 'Form'].create({
                  params: context,
                  formType: context.form
                });

      if (context.position) {
        rootView.adjustPosition(context.position);
      }

      rootView.set('currentView', form);
      manager.goToState('open');
    },
    closeForm: Ember.K()
  }),

  open: Ember.State.create({
    closeForm: function(manager, context) {
      manager.setPath('rootView.currentView', null);
      manager.goToState('empty');
      
      if (context) {
        context.stopPropagation();
        return false;
      }
    },
    showForm: function(manager, context) {
      var rootView = manager.get('rootView'),
          form = Radium[context.form + 'Form'].create({
                    params: context,
                    formType: context.form
                  });

      if (rootView.get('currentView')) {
        rootView.set('currentView', null);
        
        if (context.position) {
          rootView.adjustPosition(context.position);
        }

        rootView.set('currentView', form);
      } else {
        manager.send('closeForm');
      }
    }
  })
});
