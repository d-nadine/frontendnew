define('views/forms/todo_form', function(require) {
  
  var Radium = require('radium'),
      template = require('text!templates/forms/todo_form.handlebars'),
      reminderForm = require('text!templates/forms/reminder.handlebars');

  Radium.TodoFormView = Radium.FormView.extend({
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
    }.observes('wantsReminder'),
    submitForm: function() {
      var vals = this.$('form').serializeArray();
      var createObject = {};
      vals.forEach(function(item) {
        createObject[item.name] = item.value;
      });

      var finishByDate = createObject.date.split('/');
      var finishByTime = createObject.time.split(':');

      // var todo = Radium.store.createRecord(Radium.Todo, {
      //   kind: "general",
      //   finished: false,
      //   finishBy: Ember.DateTime.create({
      //     date: finishByDate[1],
      //     month: finishByDate[0],
      //     year: finishByDate[2],
      //     hour: finishByTime[0],
      //     minute: finishByTime[1]
      //   }).toISO8601(),
      //   description: createObject.description,
      //   contacts: [],
      //   user: []
      // });
      Radium.App.goToState('load');
    },
    template: Ember.Handlebars.compile(template)
  });

  return Radium;
});