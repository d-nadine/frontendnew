// NOTE: Likely will be depreciated
Radium.FieldValidation = Ember.Mixin.create({
  didInsertElement: function() {
    this._super();
    this.getPath('parentView.invalidFields').addObject(this);
  },

  willDestroy: function() {
    this.getPath('parentView.errors').clear();
  },

  isErrorBinding: 'parentView.isError',

  methods: {
    required: function(val) {
      var value = $.trim(val);
      return value.length > 0;
    }
  },

  errorMessages: {
    required: "This field is required."
  },

  keyUp: function(event) {
    this._super(event);
    this.testRules();
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