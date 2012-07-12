Radium.FormReminder = Ember.Mixin.create({
  reminderForm: Ember.Select.extend({
    content: Ember.A([
      {value: "300", label: "Right before!"},
      {value: "1800", label: "Half hour"},
      {value: "3600", label: "An hour"},
      {value: "10800", label: "3 hours"},
      {value: "86400", label: "A day"},
      {value: "259200", label: "3 Days"}
    ]),
    optionLabelPath: 'content.label',
    optionValuePath: 'content.value',
    viewName: 'reminderSelect',
    classNames: ['inline-fieldset'],
    didInsertElement: function() {
      this.$().before('<label for="todo-reminder">Remind Me:</label>');
    }
  })
});
