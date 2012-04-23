Radium.InlineDatePicker = Ember.View.extend({
  tagName: 'span',
  templateName: 'inline_datepicker',
  attributeBindings: ['title'],
  title: "Click to edit due date",
  isEditing: false,
  click: function(event) {
    this.set('isEditing', true);
  },
  keyUp: function(event) {
    event.preventDefault();
    if (event.keyCode === 13) {
      this.set('isEditing', false);
      Radium.store.commit();
    }
    if (event.keyCode === 27) {
      this.set('isEditing', false);
    }
  },
  change: function() {
    this.set('isEditing', false);
  },
  inlineDatePicker: Ember.TextField.extend({
    classNames: ['input-small'],
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
          return value;
        }
        
      }
    }).from('parentView.value'),
    didInsertElement: function() {
      this.set('_cachedValue', this.get('value'));
      this.$().datepicker({
        dateFormat: 'yy-mm-dd',
        minDate: new Date(),
        defaultDate: +1,
        gotoCurrent: true
      }).focus();
    },
    willDestroyElement: function() {
      this.$().datepicker("destroy");
      this.set('_cachedValue', null);
    },
    change: function() {
      this._super();
      if (this.get('_cachedValue') !== this.get('value')) {
        Radium.store.commit();
      }
    },
    focusOut: function() {
      this._super();
      this.setPath('parentView.isEditing', false);
    }
  })
});