Radium.PageState = Ember.ViewState.extend({
  form: Ember.State.create({
    form: null,
    formType: 'Todo',
    enter: function() {
      var type = this.get('formType');
      var form = this.get('form') || Radium[type+'FormView'].create();
      form.appendTo('#form-container');
      this.set('form', form);
      this.setPath('parentState.isFormAddView', true);
    },
    exit: function() {
      this.get('form').destroy();
      this.set('form', null);
      this.setPath('parentState.isFormAddView', false);
    }
  })
});
