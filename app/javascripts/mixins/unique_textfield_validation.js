Radium.UniqueTextFieldValidation = Ember.Mixin.create({
  // Quickie validation to see if a entered name/string is unique
  // Requires `storedNames` property
  uniqueNameTest: function(value) {
    var newName = value.toLowerCase(),
        existingNames = this.get('storedNames').compact(),
        lowercaseNames = existingNames.map(function(name) {
          return name.toLowerCase();
        });
    return (lowercaseNames.indexOf(newName) >= 0) ? false : true;
  },
  
  keyUp: function() {
    if (this.$().val() !== '') {
      this.setPath('parentView.isValid', true);
      this.setPath('parentView.isError', false);
      this.setPath('parentView.isEmptyError', false);
    }
  },

  focusOut: function(event) {
    var value = this.$().val();
    if (value !== '') {
      // Check the uniquness of the name first
      if (!this.uniqueNameTest(value)) {
        this.setPath('parentView.isMatchError', true);
        this.setError();
        return false;
      }

      this.setPath('parentView.isMatchError', false);
      this.setPath('parentView.isEmptyError', false);
      this.setPath('parentView.isValid', true);
      this.setPath('parentView.isError', false);
    } else {
      this.setPath('parentView.isEmptyError', true);
      this.setError();
    }
  },

  setError: function() {
    this.setPath('parentView.isError', true);
    this.setPath('parentView.isValid', false);
  }
});