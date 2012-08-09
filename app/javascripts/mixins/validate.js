Radium.Validate = Ember.Mixin.create({
  // Requires a controller attached to the parent view.
  controllerBinding: 'parentView.controller',
  classNameBindings: ['isInvalid:is-error', 'isValid'],
  didInsertElement: function() {
    this._super();
    this.getPath('controller.invalidFields').pushObject(this);
  },
  keyUp: function(event) {
    this._super(event);
    this.runValidation();
  },
  focusOut: function(event) {
    this._super(event);
    this.runValidation();
  },
  runValidation: function() {
    var invalidFields = this.getPath('controller.invalidFields');
    if (this.validate()) {
      this.setProperties({
        isInvalid: false,
        isValid: true
      });
      invalidFields.removeObject(this);
    } else {
      this.setProperties({
        isInvalid: true,
        isValid: false
      });
      if (invalidFields.indexOf(this) === -1) {
        invalidFields.pushObject(this);
      }
    }
  }
});