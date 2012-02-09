define('views/forms/call_list_form', function(require) {
  var Radium = require('radium'),
    template = require('text!templates/forms/call_list_form.handlebars'),
    reminderForm = require('text!templates/forms/reminder.handlebars');

  Radium.CallListFormView = Radium.FormView.extend({
    template: Ember.Handlebars.compile(template),
    wantsReminder: false,
    reminderForm: Ember.View.extend({
      id: 'add-reminder',
      template: Ember.Handlebars.compile(reminderForm)
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
    }.observes('wantsReminder')
  });

  return Radium;
});