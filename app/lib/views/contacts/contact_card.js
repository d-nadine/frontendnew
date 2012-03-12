Radium.ContactCardView = Ember.View.extend({
  templateName: 'contact_card',
  classNames: "contact-card row span9".w(),
  classNameBindings: ['content.isSelected:selected']
});