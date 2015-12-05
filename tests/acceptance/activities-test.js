import { test } from 'qunit';
import moduleForAcceptance from 'radium/tests/helpers/module-for-acceptance';
import PageObject from "../page-object";

import { createCurrentUser } from '../helpers/fixture-helpers';

const {
  visitable
} = PageObject;

const page = PageObject.build({
  visit: visitable('/users/:user_id'),
  feedIsVisible: PageObject.isVisible('.activity-feed-component'),
  activities: PageObject.collection({
    itemScope: '.activity-feed-component .activity',
    item: {
      time: PageObject.text('time'),
      hasCorrectIcon: PageObject.hasClass('ss-star', 'i'),
      description: PageObject.text('p')
    }
  })
});

moduleForAcceptance('Acceptance | activities');

test('a user has an activity feed', function(assert) {
  assert.expect(8);

  let current_user = createCurrentUser(),
      contact = server.create('contact', {name: 'Bob Hoskins', account_id: current_user.account_id}),
      company = server.create('company', {name: "Acme Ltd.", account_id: current_user.account_id});

  server.create('activity', {
    user_id: current_user.id,
    account_id: current_user.account_id,
    tag: 'contact',
    event: 'create',
    time: moment().add(-3, 'd'),
    _reference_contact_id: contact.id,
    description: "added as a contact"
  });

  server.create('activity', {
    user_id: current_user.id,
    account_id: current_user.account_id,
    tag: 'company',
    event: 'create',
    time: moment().add(-4, 'd'),
    _reference_company_id: company.id,
    description: "added as a company"
  });

  page.visit({user_id: current_user.id});

  andThen(function() {
    assert.equal(currentURL(), `/users/${current_user.id}`);

    assert.ok(page.feedIsVisible(), "feed component is on page");

    assert.equal(2, page.activities().count());

    const createContact = page.activities(1);

    assert.equal('3 days', createContact.time());

    assert.ok(createContact.hasCorrectIcon(), 'create contact has create icon');

    assert.equal(`${contact.name} added as a contact by ${current_user.first_name} ${current_user.last_name}`, createContact.description(), 'correct contact event text');

    const createCompany = page.activities(2);

    assert.equal('4 days', createCompany.time());

    assert.equal(`${company.name} added as a company by ${current_user.first_name} ${current_user.last_name}`, createCompany.description(), 'correct contact event text');
  });
});
