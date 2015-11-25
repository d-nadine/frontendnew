export function createCurrentUser() {
  let subscriptionPlan = server.create('subscription-plan');
  let billing = server.create('billing', {subscription_plan_id: subscriptionPlan.id});
  let account = server.create('account', {billing_id: billing.id});

  return server.create('user', {account_id: account.id, first_name: 'Paul', last_name: 'Cowan', email: 'paul@radiumcrm.com'});
}
