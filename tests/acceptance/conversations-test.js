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
  drawerIsVisible: PageObject.isVisible('.drawer-view'),
  usersTotals: PageObject.collection({
    itemScope: '#assigned .user-total',
    item: {
      name: PageObject.text('.who'),
      total: PageObject.text('.badge'),
      route: PageObject.clickable('.who')
    }
  }),
  conversations: PageObject.collection({
    itemScope: '.variadic-table tbody tr',
    item: {
      contact: PageObject.text('td:nth-of-type(2) a'),
      contactLink: PageObject.clickable('td:nth-of-type(2) a')
    }
  }),

  drawer: PageObject.component({
    toggleIsVisible: PageObject.isVisible('.toggle-switch-component'),
    togglePublic: PageObject.clickable('.toggle-switch-component input[type=checkbox]')
  })
});

module('Acceptance | conversations', {
  beforeEach: function() {
    this.application = startApp();
    let subscriptionPlan = server.create('subscription-plan');
    let billing = server.create('billing', {subscription_plan_id: subscriptionPlan.id});
    let account = server.create('account', {billing_id: billing.id});
    let current_user = server.create('user', {account_id: account.id, first_name: 'Paul', last_name: 'Cowan', email: 'paul@radiumcrm.com'});
    let other_user = server.create('user', {account_id: account.id, first_name: 'Sue', last_name: 'Barker', email: 'sue@radiumcrm.com'});

    let contact = server.create('contact', {name: 'Bob Hoskins', account_id: account.id});

    server.create('email',
                  {account_id: account.id,
                   _sender_contact_id: contact.id,
                   to_user_ids: [current_user.id]});

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

test('conversations totals are displayed and can route to', function(assert) {
  assert.expect(9);

  page.visit({type: 'incoming'});

  andThen(function() {
    assert.equal(currentURL(), '/conversations/incoming');

    assert.equal('8', page.incoming(), 'correct incoming total');
    assert.equal('9', page.waiting(), 'correct waiting total');
    assert.equal('10', page.later(), 'correct later total');
    assert.equal(1, page.usersTotals().count(), 'correct users totals');

    const userTotal = page.usersTotals(1);

    assert.notEqual('Paul Cowan', userTotal.name(), 'user total is not current user');
    assert.equal('2', userTotal.total(), 'correct user total');

    userTotal.route().route();

    andThen(function() {
      const userId = server.db.users.filter(function(user) { return user.first_name === 'Sue';})[0].id;

      assert.ok($(userTotal.scope).parent().hasClass('active'), 'active class is on user total');
      assert.equal(currentURL(), `/conversations/team?user=${userId}`, 'current url is team url');
    });
  });
});

test('variadic table row is rendered for each email', function(assert) {
  assert.expect(2);

  page.visit({type: 'incoming'});

  andThen(function() {
    assert.equal(1, page.conversations().count(), 'there are 1 conversations');
    assert.equal("Bob Hoskins", page.conversations(1).contact(), 'the correct contact is conversation number 1');
  });
});

test('can trigger drawer and perform actions', function(assert) {
  assert.expect(4);

  page.visit({type: 'incoming'});

  const getContact = () => {
    return server.db.contacts.where({name: 'Bob Hoskins'})[0];
  };

  andThen(function() {
    assert.equal(1, page.conversations().count());

    page.conversations(1).contactLink();

    assert.notOk(getContact().public, 'precon - the contact is not public prior to clicking toggle switch');
  });

  andThen(function() {
    assert.ok(page.drawerIsVisible());

    page.drawer().togglePublic();
  });

  andThen(function() {
    assert.ok(getContact().public, 'the contact is public after clicking switch');
  });
});
