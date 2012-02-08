define('views/forms/todo_form', function(require) {
  
  var Radium = require('radium'),
      template = require('text!templates/forms/todo_form.handlebars');

  Radium.TodoFormView = Radium.FormView.extend({
    template: Ember.Handlebars.compile(template),
    wantsReminder: false,
    addReminder: Ember.View.extend({
      isVisible: function() {
        return this.getPath('parentView.wantsReminder');
      }.property('parentView.wantsReminder').cacheable()
    }),
    submitForm: function() {
      console.log(this.$().serialize());
    },
    cancelForm: function() {
      var self = this;
      this.$().slideUp('fast', function() {
        self.remove();
      });
    }
  });

  return Radium;
});