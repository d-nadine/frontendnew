Radium.InlineMessageForm = Ember.Mixin.create({
  showMessageForm: function(event) {
    var childViews = this.get('childViews'),
        messageForm = this.get('messageForm');
    
    if (childViews.indexOf(messageForm) === -1) {
      childViews.pushObject(messageForm);
    } else {
      childViews.removeObject(messageForm);
    }
    
    return false;
  },
  
  init: function() {
    this._super();
    var content = this.get('content'),
        controller = Ember.Object.create({
          to: Ember.A([]),
          cc: Ember.A([]),
          bcc: Ember.A([])
        });

    controller.get('to').pushObject({
        name: content.get('displayName'),
        email: content.getPath('emailAddresses.firstObject.value')
      });

    this.set('messageForm', Radium.MessageForm.create({
      controller: controller
    }));
  }
});