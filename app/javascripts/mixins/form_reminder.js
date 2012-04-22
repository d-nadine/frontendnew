Radium.FormReminder = Ember.Mixin.create({
  reminderForm: Ember.View.extend({
    tagName: 'fieldset',
    id: 'add-reminder',
    templateName: 'reminder',
  })
});