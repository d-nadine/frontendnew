export default function(server) {
  console.log('we do not get here');
  let subscriptionPlan = server.createSubscriptionPlan();
  let billing = server.createBilling({subscription_plan_id: subscriptionPlan.id});
  let account = server.createAccount({billing_id: billing.id});
  server.createUser({account_id: account.id});
}
