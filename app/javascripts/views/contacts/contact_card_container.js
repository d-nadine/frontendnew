Radium.ContactCardContainerView = Ember.ContainerView.extend(
  Radium.InlineForm,
  Radium.InlineMessageForm,
  Radium.InlineTodoForm, {
  classNames: 'contact-card-container'.w(),
  init: function() {
    this._super();
    this.set('childViews', []);

    var content = this.get('content'),
        contactCard = Radium.ContactCardView.create({
          content: content
        });
    this.set('currentView', contactCard);
  }
});