Radium.FormContainerView = Ember.ContainerView.create({
  elementId: 'form-container',
  
  isVisible: function() {
    return (this.get('currentView')) ? true : false;
  }.property('currentView'),

  close: function(event) {
    var self = this,
        form = this.get('currentView');

    $('#main-feed').animate({
      top: 0
    }, 'fast');
    
    form.set('isGlobalLevelForm', false);
    form.$().slideUp('fast', function() {
      self.set('currentView', null);
      form.destroy();
    });
    return false;
  },

  show: function(form) {
    form.set('isGlobalLevelForm', true);
    this.set('currentView', form);
  },

  // Individual Forms
  showEmailForm: function(event) {
    var controller = Ember.Object.create({
          to: Ember.A([]),
          cc: Ember.A([]),
          bcc: Ember.A([])
        }),
        context = (event) ? event.context : null;

    if (Ember.Array.detect(context)) {
      // TODO: Can't seem to send the selectedContacts property array through
      // the context via the action helper. Have to pass the controller instead.
      var selectedEmails = context.get('selectedContacts').map(function(item) {
        return {
          name: item.get('name'),
          email: item.get('email')
        };
      });
      controller.get('to').pushObjects(selectedEmails);
    } else {
      controller.get('to').pushObject({
        name: context.get('name'),
        email: context.get('email')
      });
    }

    this.show(Radium.MessageForm.create({
      controller: controller
    }));

    return false;
  },

  showTodoForm: function(event) {
    var context = (event) ? event.context : null,
        // Test if context is an array controller versus an object
        isArray = Ember.Array.detect(context),
        // If it is an array, we wanted the selected computed property,
        // but if not, just pass the defined object along.
        multipleBinding = {
          source: context,
          selectionBinding: 'source.selectedContacts'
        },
        singleBinding = {
          selection: context
        },
        selection = (isArray) ? multipleBinding : singleBinding;

    this.show(Radium.TodoForm.create(selection));

    return false;
  },

  showDiscussionForm: function(event) {
    var form = Radium.DiscussionForm.create();
    this.show(form);
    return false;
  },

  showDealForm: function(event) {
    var form = Radium.DealForm.create();
    this.show(form);
    return false;
  },

  showMeetingForm: function(event) {
    var form = Radium.MeetingForm.create();
    this.show(form);
    return false;
  },

  showContactForm: function(event) {
    var form = Radium.ContactForm.create();
    this.show(form);
    return false;
  },

  showAddToGroupForm: function(event) {
    var form = Radium.AddToGroupForm.create();
    this.show(form);
    return false;
  }
}).append();