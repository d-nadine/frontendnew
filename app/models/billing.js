import Model from 'radium/models/models';
import Ember from 'ember';

const Billing = Model.extend({
  gatewayIdentifier: DS.attr('string'),
  token: DS.attr('string'),
  organisation: DS.attr('string'),
  billingEmail: DS.attr('string'),
  reference: DS.attr('string'),
  phone: DS.attr('string'),
  country: DS.attr('string'),
  vat: DS.attr('string'),
  trialStartDate: DS.attr('datetime'),
  nextPaymentDue: DS.attr('datetime'),
  subscriptionEnded: DS.attr('boolean'),
  subscriptionEndDate: DS.attr('datetime'),
  gatewaySet: DS.attr('boolean'),
  isTrial: DS.attr('boolean'),
  subscriptionInvalid: DS.attr('boolean'),

  subscriptionPlan: DS.belongsTo('Radium.SubscriptionPlan'),

  isBasic: Ember.computed('subscriptionPlan.planId', function() {
    return this.get('subscriptionPlan.planId') === 'basic';
  }),
  hasSubscription: Ember.computed('subscriptionPlan', 'gatewaySet', function() {
    if (this.get('subscriptionEnded')) {
      return false;
    }
    return this.get('gatewaySet') && !this.get('isBasic');
  })
});

export default Billing;

Billing.toString = function() {
  return "Radium.Billing";
};