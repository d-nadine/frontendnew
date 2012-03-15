Radium.TodoForm = Radium.FormView.extend({
  wantsReminder: false,
  reminderForm: Ember.View.extend({
    id: 'add-reminder',
    templateName: 'reminder'
  }),
  reminderFormCache: null,
  addReminder: function() {
    // Cache the reminder form view so it can be destroyed and therefore
    // prevented from being submitted to the `submitForm` method
    var reminderForm = this.get('reminderFormCache') || this.reminderForm.create();
    this.set('reminderFormCache', reminderForm);
    if (this.get('wantsReminder')) {
      reminderForm.appendTo('#reminder-holder');
    } else {
      this.get('reminderFormCache').destroy();
      this.set('reminderFormCache', null);
    }
  }.observes('wantsReminder'),
  templateName: 'todo_form'
});