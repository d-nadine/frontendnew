import { test } from 'qunit';
import moduleForAcceptance from 'radium/tests/helpers/module-for-acceptance';
import PageObject from "../page-object";

const {
  visitable
} = PageObject;

const page = PageObject.build({
  visit: visitable('/users/:user_id'),
  feedIsVisible: PageObject.isVisible('.activity-feed-component')
});

moduleForAcceptance('Acceptance | activities');

test('a user has an activity feed', function(assert) {
  let subscriptionPlan = server.create('subscription-plan');
  let billing = server.create('billing', {subscription_plan_id: subscriptionPlan.id});
  let account = server.create('account', {billing_id: billing.id});
  let current_user = server.create('user', {account_id: account.id, first_name: 'Paul', last_name: 'Cowan', email: 'paul@radiumcrm.com'});

  page.visit({user_id: current_user.id});

  andThen(function() {
    assert.equal(currentURL(), `/users/${current_user.id}`);

    assert.ok(page.feedIsVisible(), "feed component is on page");
  });
});
