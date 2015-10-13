import Model from 'radium/models/models';

const SubscriptionPlan = Model.extend({
  planId: DS.attr('string'),
  name: DS.attr('string'),
  amount: DS.attr('number'),
  interval: DS.attr('string'),
  currency: DS.attr('string'),
  totalUsers: DS.attr('number'),
  disabled: DS.attr('boolean'),
  displayOrder: DS.attr('number')
});

export default SubscriptionPlan;

SubscriptionPlan.toString = function() {
  return "Radium.SubscriptionPlan";
};