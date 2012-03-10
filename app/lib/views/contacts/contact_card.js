Radium.ContactCardView = Ember.View.extend({
  templateName: 'contact_card',
  classNames: "contact-card row".w(),
  classNameBindings: ['content.isSelected:selected']
});