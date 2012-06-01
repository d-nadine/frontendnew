Radium.FormContainerView = Ember.ContainerView.create({
  elementId: 'form-container',
  isVisible: function() {
    return (this.get('currentView')) ? true : false;
  }.property('currentView'),
  show: function(context) {
    var form = Radium[context.form + 'Form'].create({
      formType: context.form,
      params: context
    });

    this.set('currentView', form);
    
  },
  close: function(event) {
    var self = this,
        form = this.get('currentView');
    form.$().fadeOut('fast', function() {
      self.set('currentView', null);
    });
    return false;
  }
}).append();