Radium.FormView = Ember.View.extend({
  /**
    Default submit form action.
  */
  didInsertElement: function() {
    this._super();
    this.$().hide().slideDown('slow');
  },
  submitForm: function() {
    var vals = this.$('form').serializeArray();
    var createObject = {};
    vals.forEach(function(item) {
      createObject[item.name] = item.value;
    });

    this.$().slideUp('fast', function() {
      Radium.App.goToState('load');
    });
  },
  cancelForm: function() {
    this.$().slideUp('fast', function() {
      Radium.App.goToState('load');
    });
  },
  submitButton: Ember.Button.extend({
    target: 'parentView',
    action: 'submitForm'
  }),
  cancelFormButton: Ember.Button.extend({
    target: 'parentView',
    action: 'cancelForm'
  })
});