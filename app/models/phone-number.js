import Model from 'radium/models/models';

const PhoneNumber = Model.extend({
  name: DS.attr('string'),
  value: DS.attr('string'),
  isPrimary: DS.attr('boolean')
});

export default PhoneNumber;

PhoneNumber.toString = function() {
  return "Radium.PhoneNumber";
};