import Model from 'radium/models/models';

const EmailAddress = Model.extend({
  name: DS.attr('string'),
  value: DS.attr('string'),
  isPrimary: DS.attr('boolean')
});

export default EmailAddress;

EmailAddress.toString = function() {
  return "Radium.EmailAddress";
};