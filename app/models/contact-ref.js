import Model from 'radium/models/models';

const ContactRef = Model.extend({
  contact: DS.belongsTo('Radium.Contact')
});

export default ContactRef;

ContactRef.toString = function() {
  return "Radium.ContactRef";
};
