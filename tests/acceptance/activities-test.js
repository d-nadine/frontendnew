import { test } from 'qunit';
import moduleForAcceptance from 'radium/tests/helpers/module-for-acceptance';
import PageObject from "../page-object";

import { createCurrentUser } from '../helpers/fixture-helpers';

const {
  visitable
} = PageObject;

const activitiesProps = {
  itemScope: '.activity-feed-component .activity',
  item: {
    time: PageObject.text('time'),
    hasStarIcon: PageObject.hasClass('ss-star', 'i'),
    hasNoteIcon: PageObject.hasClass('ss-notebook', 'i'),
    hasEmailIcon: PageObject.hasClass('ss-mail', 'i'),
    hasOpenedIcon: PageObject.hasClass('ss-view', 'i'),
    hasReassignIcon: PageObject.hasClass('ss-transfer', 'i'),
    description: PageObject.text('p span:first'),
    noteBody: PageObject.text('.note-container'),
    emailBody: PageObject.text('.email-container'),
    replyIsVisible: PageObject.isVisible('.ss-reply'),
    emailSubject: PageObject.text('.email-subject')
  }
};

const feedIsVisible = PageObject.isVisible('.activity-feed-component');

const usersPage = PageObject.build({
  visit: visitable('/users/:user_id'),
  feedIsVisible: feedIsVisible,
  activities: PageObject.collection(activitiesProps)
});

const contactsPage = PageObject.build({
  visit: visitable('/contacts/:contact_id'),
  feedIsVisible: feedIsVisible,
  activities: PageObject.collection(activitiesProps)
});

const dealPage = PageObject.build({
  visit: visitable('/deals/:deal_id'),
  feedIsVisible: feedIsVisible,
  activities: PageObject.collection(activitiesProps)
});

moduleForAcceptance('Acceptance | activities');

test('a deal can have an activity feed', function(assert) {

  let current_user = createCurrentUser(),
      deal = server.create('deal', {name: 'The deal', account_id: current_user.account_id}),
      other_user = server.create('user', {account_id: current_user.account_id, first_name: 'Sue', last_name: 'Barker', email: 'sue@radiumcrm.com'});

  server.create('activity', {
    user_id: current_user.id,
    _reference_deal_id: deal.id,
    account_id: current_user.account_id,
    tag: 'deal',
    event: 'assign',
    time: moment().add(-2, 'd'),
    description: "assigned to",
    assigned_to_user_id: other_user.id
  });

  dealPage.visit({deal_id: deal.id});

  assert.expect(3);

  andThen(function() {
    assert.equal(dealPage.activities().count(), 1, 'correct number of deal activities');

    const assignedToActivity = dealPage.activities(1);

    assert.ok(assignedToActivity.hasReassignIcon(), 'activity icon has reassign deal icon');

    assert.equal(`Deal ${deal.name} assigned to ${other_user.fullName} by ${current_user.fullName}`, assignedToActivity.description(), 'deal reassign activity has correct description');
  });
});

test('a contact can have an activity feed', function(assert) {

  let current_user = createCurrentUser(),
      contact = server.create('contact', {name: 'Bob Hoskins', account_id: current_user.account_id}),
      todo = server.create('todo', {
        description: "A todo"
      }),
      other_user = server.create('user', {account_id: current_user.account_id, first_name: 'Sue', last_name: 'Barker', email: 'sue@radiumcrm.com'});

  server.create('activity', {
    user_id: current_user.id,
    _reference_contact_id: contact.id,
    account_id: current_user.account_id,
    tag: 'Todo',
    event: 'create',
    time: moment().add(-1, 'd'),
    todo_id: todo.id,
    description: "created"
  });

  server.create('activity', {
    user_id: current_user.id,
    _reference_contact_id: contact.id,
    account_id: current_user.account_id,
    tag: 'contact',
    event: 'assign',
    time: moment().add(-2, 'd'),
    description: "assigned to",
    assigned_to_user_id: other_user.id
  });

  assert.expect(6);

  contactsPage.visit({contact_id: contact.id});

  andThen(function() {
    assert.equal(currentURL(), `/contacts/${contact.id}`);

    assert.ok(contactsPage.feedIsVisible(), "feed component is on page");

    assert.equal(contactsPage.activities().count(), 2, 'correct number of contact activities');

    const createTodo = contactsPage.activities(1);

    assert.equal(`Todo ${todo.description} created by ${current_user.first_name} ${current_user.last_name}`, createTodo.description(), 'correct meeting event text');

    const assignedToActivity = contactsPage.activities(2);

    assert.ok(assignedToActivity.hasReassignIcon(), 'activity icon has reassign icon');

    assert.equal(`Contact ${contact.name} assigned to ${other_user.fullName} by ${current_user.fullName}`, assignedToActivity.description(), 'contact reassign activity has correct description');
  });
});

test('a user has an activity feed', function(assert) {
  assert.expect(10);

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

  const todo = server.create('todo', {
    description: "A todo"
  });

  server.create('activity', {
    user_id: current_user.id,
    account_id: current_user.account_id,
    tag: 'Todo',
    event: 'create',
    time: moment().add(-5, 'd'),
    _reference_todo_id: todo.id,
    description: "created"
  });

  const meeting = server.create('meeting', {
    _organizer_user_id: current_user.id
  });

  server.create('activity', {
    user_id: current_user.id,
    account_id: current_user.account_id,
    tag: 'Meeting',
    event: 'create',
    time: moment().add(-5, 'd'),
    _reference_meeting_id: meeting.id,
    description: "created"
  });

  usersPage.visit({user_id: current_user.id});

  andThen(function() {
    assert.equal(currentURL(), `/users/${current_user.id}`);

    assert.ok(usersPage.feedIsVisible(), "feed component is on page");

    assert.equal(4, usersPage.activities().count());

    const createContact = usersPage.activities(1);

    assert.equal('3 days', createContact.time());

    assert.ok(createContact.hasStarIcon(), 'create contact has create icon');

    assert.equal(`Contact ${contact.name} added as a contact by ${current_user.first_name} ${current_user.last_name}`, createContact.description(), 'correct contact event text');

    const createCompany = usersPage.activities(2);

    assert.equal('4 days', createCompany.time());

    assert.equal(`Company ${company.name} added as a company by ${current_user.first_name} ${current_user.last_name}`, createCompany.description(), 'correct company event text');

    const createTodo = usersPage.activities(3);

    assert.equal(`Todo ${todo.description} created by ${current_user.first_name} ${current_user.last_name}`, createTodo.description(), 'correct meeting event text');

    const createMeeting = usersPage.activities(4);

    assert.equal(`Meeting ${meeting.topic} created by ${current_user.first_name} ${current_user.last_name}`, createMeeting.description(), 'correct meeting event text');
  });
});

test('activity feed tracks emails', function(assert) {
  assert.expect(21);

  let current_user = createCurrentUser(),
      contact = server.create('contact', {name: 'Bob Hoskins', account_id: current_user.account_id}),
      fromContactEmail = server.create('email', {
        subject: 'from contact subject',
        body: 'from contact body',
        account_id: current_user.account_id,
        _sender_contact_id: contact.id,
        to_user_ids: [current_user.id]
      }),
      fromUserEmail = server.create('email', {
        subject: 'from user subject',
        body: 'from user body',
        account_id: current_user.account_id,
        _sender_user_id: current_user.id,
        to_contact_ids: [contact.id]
      }),
      openedEmail = server.create('email', {
        subject: 'opened email',
        body: 'opened email body',
        account_id: current_user.account_id,
        _sender_user_id: current_user.id,
        to_contact_ids: [contact.id]
      });

  server.create('activity', {
    user_id: current_user.id,
    account_id: current_user.account_id,
    tag: 'contact',
    event: 'new_email',
    time: moment().add(-3, 'd'),
    email_id: fromContactEmail.id
  });

  server.create('activity', {
    user_id: current_user.id,
    account_id: current_user.account_id,
    tag: 'contact',
    event: 'sent_email',
    time: moment().add(-5, 'd'),
    email_id: fromUserEmail.id
  });

  server.create('activity', {
    user_id: current_user.id,
    account_id: current_user.account_id,
    _reference_contact_id: contact.id,
    tag: 'contact',
    event: 'open',
    email_id: openedEmail.id,
    time: moment().add(-6, 'd'),
    description: 'opened the email'
  });

  server.create('activity', {
    user_id: current_user.id,
    account_id: current_user.account_id,
    _reference_contact_id: contact.id,
    tag: 'contact',
    event: 'click',
    email_id: openedEmail.id,
    time: moment().add(-7, 'd'),
    description: 'clicked the link',
    external_link: "http://thesoftwaresimpleton.com"
  });

  usersPage.visit({user_id: current_user.id});

  andThen(function() {
    assert.equal(currentURL(), `/users/${current_user.id}`, 'At users activity feed');

    assert.ok(usersPage.feedIsVisible(), "feed component is on page", 'feed is visible');

    assert.equal(4, usersPage.activities().count());

    const fromContactEmailActivity = usersPage.activities(1);

    assert.equal('3 days', fromContactEmailActivity.time(), 'correct activity time');

    assert.ok(fromContactEmailActivity.hasEmailIcon(), 'activity has correct icon');

    assert.equal(`${contact.name} emailed ${current_user.fullName}`, fromContactEmailActivity.description(), 'activity has correct description');

    assert.ok(fromContactEmailActivity.replyIsVisible(), 'reply link is visible');

    assert.equal('from contact subject', fromContactEmailActivity.emailSubject(), 'email subject from contact is visible');

    assert.equal('from contact body', fromContactEmailActivity.emailBody(), 'email body text is from contact visible');

    const fromUserEmailActivity = usersPage.activities(2);

    assert.equal('5 days', fromUserEmailActivity.time(), 'correct activity time');

    assert.ok(fromUserEmailActivity.hasEmailIcon(), 'activity has correct icon');

    assert.equal(`${current_user.fullName} emailed ${contact.name}`, fromUserEmailActivity.description(), 'activity has correct description');

    assert.ok(fromUserEmailActivity.replyIsVisible(), 'reply link is visible');

    assert.equal('from user subject', fromUserEmailActivity.emailSubject(), 'email subject from user is visible');

    assert.equal('from user body', fromUserEmailActivity.emailBody(), 'email body text from user is visible');

    const openedEmailActivity = usersPage.activities(3);

    assert.equal('6 days', openedEmailActivity.time(), 'correct activity time');

    assert.ok(openedEmailActivity.hasOpenedIcon(), 'activity has open email icon');

    assert.equal(`${contact.name} opened the email`, openedEmailActivity.description(), 'activity has correct description');

    const clickedLinkActivity = usersPage.activities(4);

    assert.equal('7 days', clickedLinkActivity.time(), 'correct activity time');

    assert.ok(clickedLinkActivity.hasOpenedIcon(), 'activity has open email icon');

    assert.equal(clickedLinkActivity.description(), `${contact.name} clicked the link in the email`, 'activity has correct description');
  });
});

test('an activity feed item can contain a note', function(assert) {
  assert.expect(7);

  let current_user = createCurrentUser(),
      note = server.create('note', {body: 'This is a note', user_id: current_user.id});

  server.create('activity', {
    user_id: current_user.id,
    account_id: current_user.account_id,
    tag: 'note',
    event: 'create',
    time: moment().add(-3, 'd'),
    note: note
  });

  usersPage.visit({user_id: current_user.id});

  andThen(function() {
    assert.equal(currentURL(), `/users/${current_user.id}`, 'At users activity feed');

    assert.ok(usersPage.feedIsVisible(), "feed component is on page", 'feed is visible');

    assert.equal(1, usersPage.activities().count());

    const noteActivity = usersPage.activities(1);

    assert.equal('3 days', noteActivity.time(), 'correct activity time');

    assert.ok(noteActivity.hasNoteIcon(), 'create note has create icon');

    assert.equal(`${current_user.first_name} ${current_user.last_name} added a note:`, noteActivity.description(), 'note activity has correct description');

    assert.equal('This is a note', noteActivity.noteBody(), 'note body has correct description');
  });
});
