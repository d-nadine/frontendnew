import Ember from 'ember';
import { module, test } from 'qunit';
import startApp from 'radium/tests/helpers/start-app';
import PageObject from '../page-object';

const {
  visitable
} = PageObject;

const page = PageObject.build({
  visit: visitable('/conversations/:type'),
  incoming: PageObject.text('.conversations-sidebar #totals a:nth-of-type(1) span'),
  waiting: PageObject.text('.conversations-sidebar #totals a:nth-of-type(2) span'),
  later: PageObject.text('.conversations-sidebar #totals a:nth-of-type(3) span'),
  usersTotals: PageObject.collection({
    itemScope: '#assigned .user-total',
    item: {
      name: PageObject.text('.who'),
      total: PageObject.text('.badge')
    }
  })
});

module('Acceptance | conversations', {
  beforeEach: function() {
    this.application = startApp();
    let subscriptionPlan = server.create('subscription-plan');
    let billing = server.create('billing', {subscription_plan_id: subscriptionPlan.id});
    let account = server.create('account', {billing_id: billing.id});
    server.create('user', {account_id: account.id, first_name: 'Paul', last_name: 'Cowan', email: 'paul@radiumcrm.com'});
    let other_user = server.create('user', {account_id: account.id});

    server.create('conversations-totals',{
      incoming: 8,
      waiting: 9,
      later: 10,
      users_totals: [
        {id: other_user.id, total: 2}
      ],
      all_users_totals: 0,
      shared_totals: []
    });
  },

  afterEach: function() {
    Ember.run(this.application, 'destroy');
  }
});

test('conversations totals are displayed', function(assert) {
  assert.expect(7);

  page.visit({type: 'incoming'});

  andThen(function() {
    assert.equal(currentURL(), '/conversations/incoming');

    assert.equal('8', page.incoming());
    assert.equal('9', page.waiting());
    assert.equal('10', page.later());

    assert.equal(1, page.usersTotals().count());
    assert.notEqual('Paul Cowan', page.usersTotals(1).name());
    assert.equal('2', page.usersTotals(1).total());
  });
});
