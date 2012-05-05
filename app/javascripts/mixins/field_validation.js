Radium.FieldValidation = Ember.Mixin.create({
  didInsertElement: function() {
    this.getPath('parentView.invalidFields').addObject(this);
  },

  isErrorBinding: 'parentView.isError',

  methods: {
    required: function(val) {
      var val = $.trim(val);
      return val.length > 0;
    }
  },

  errorMessages: {
    required: "This field is required."
  },

  keyUp: function(event) {
    this.testRules();
    this._super(event);
  },

  focusOut: function(event) {
    this.testRules();
    this._super(event);
  },

  testRules: function() {
    var rules = this.get('rules'),
        val = this.$().val();

    rules.forEach(function(rule) {
      if (this.get('methods')[rule](val)) {
        this.getPath('parentView.errors').removeObject(this.getPath('errorMessages.'+rule));
        this.getPath('parentView.invalidFields').removeObject(this);
      } else {
        this.getPath('parentView.invalidFields').addObject(this);
        this.getPath('parentView.errors').addObject(this.getPath('errorMessages.'+rule));
      }
    }, this);
  }
});