import DS from 'ember-data';

export default DS.Model.extend({
  name: DS.attr('string'),
  gatewaySetup: DS.attr('boolean'),
  subscriptionInvalid: DS.attr('boolean'),
  isTrial: DS.attr('boolean'),
  trialDaysLeft: DS.attr('number'),
  unlimited: DS.attr('boolean'),
  importedContactsGlobal: DS.attr('boolean'),
  currency: DS.attr('string')
});
