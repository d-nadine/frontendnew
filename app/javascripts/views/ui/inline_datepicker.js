Radium.InlineDatePicker = Ember.View.extend({
  tagName: 'span',
  templateName: 'inline_datepicker',
  attributeBindings: ['title'],
  title: "Click to edit due date",
  isEditing: false,
  newDate: null,
  click: function(event) {
    this.set('isEditing', true);
  },
  keyUp: function(event) {
    event.preventDefault();
    if (event.keyCode === 27) {
      this.set('isEditing', false);
    }
  },
  change: function() {
    this.set('isEditing', false);
  },
  datePickerDidClose: function() {
    var isEditing = this.get('isEditing'),
        newDate = this.get('newDate'),
        value = this.get('value');
    if (!isEditing) {
      if (newDate !== value) {
        this.set('value', newDate);
      }
    }
  }.observes('isEditing'),
  inlineDatePicker: Ember.TextField.extend({
    classNames: ['input-small'],
    // TODO: Move this into a config utility for DRY.
    dateConverter: function(value) {
      var dateValues;
      if (value) {
        dateValues = value.split('-');
        return new Date(Date.UTC(
          dateValues[0], 
          dateValues[1] - 1, 
          dateValues[2], 
          17));
      } else {
        return new Date().setHours(17);
      }
    },
    valueBinding: Ember.Binding.transform({
      to: function(value, binding) {
        var date = Ember.DateTime.create(new Date(value));
        return date.toFormattedString('%Y-%m-%d');
      },
      from: function(value, binding) {
        var dateValues;
        if (value) {
          dateValues = value.split('-');
          return new Date(Date.UTC(
            dateValues[0], 
            dateValues[1] - 1, 
            dateValues[2], 
            17));
        } else {
          return new Date().setHours(17);
        }
      }
    }).from('parentView.value'),
    didInsertElement: function() {
      this.set('_cachedValue', this.get('value'));
      this.$().datepicker({
        dateFormat: 'yy-mm-dd',
        minDate: new Date()
      }).focus();
    },
    willDestroyElement: function() {
      this.$().datepicker("destroy");
      this.set('_cachedValue', null);
    },
    // change: function() {
    //   this._super();
    //   if (this.get('value') === '') {
    //     this.set('value', this.get('_cachedValue'));
    //   }
    // },
    change: function() {
      var newValue = this.$().val(),
          newDate = this.dateConverter(newValue);

      if (newDate !== this.get('_cachedValue')) {
        this.setPath('parentView.newDate', newDate);
        this.setPath('parentView.isEditing', false);
      }
    }
  })
});