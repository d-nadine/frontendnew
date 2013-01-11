module 'Integration -  Inbox'

integrationTest 'an empty inbox displays the correct messages', ->
  expect(2)

  equal Radium.Email.find().get('length'), 0, 'precond - there are 0 emails'

  visit '/inbox'

  waitForSelector 'ul.messages li:first', (el) ->
    assertText el, 'No mail'

integrationTest 'a list of emails is displayed in the inbox', ->
  expect(5)

  for i in [0..4]
    Factory.create 'email'

  equal Radium.Email.find().get('length'), 5, 'precond - there are 5 emails'

  visit '/inbox'

  waitForSelector 'ul.messages', (el) ->
    sidebarEmails = $F('li', el)

    equal sidebarEmails.length, 5, '5 emails in the sidebar'

    activeEmail =  $F('li.active', el)

    equal activeEmail.length, 1, 'only 1 email is active'

  waitForSelector 'div.email > div.well', (el) ->
    userText = $F('strong:eq(0)', el).html()
    subject = $F('strong:eq(1)', el).html()

    equal 'User 1.', userText, "sender's name is displayed"
    equal 'Email 1', subject, 'subject is displayed'

integrationTest 'clicking on a sidebar email displays the correct email', ->
  email1 = Factory.create 'email'
  email2 = Factory.create 'email'

  equal Radium.Email.find().get('length'), 2, 'precond - there are 2 emails'

  visit '/inbox'

  waitForSelector 'ul.messages', (el) ->
    # sidebarEmails = $F('li', el)

    # lastEmail = $F('li:last', el)

    # equal sidebarEmails.length, 2, 'precond - 2 emails in the sidebar'

    # ok !lastEmail.hasClass('active'), 'last email is not active'

    clickEmail email2

    waitForResourceIn email2, "#email-panel", (panel) ->
      assertText panel, email2.get('subject')
      # ok lastEmail.hasClass('active'), 'last email is active'

      # subject = $F('strong:eq(1)', el).html()
      # equal 'Email 2', subject, 'Correct email is displayed'

integrationTest 'a todo can be created for each selected email', ->
  for i in [0..1]
    Factory.create 'email'

  equal Radium.Email.find().get('length'), 2, 'precond - there are 2 emails'

  todos = Radium.Todo.find()

  equal todos.get('length'), 0, 'precond - there are no todos'

  visit '/inbox'

  waitForSelector 'ul.messages', (el) ->
    checks = $F('input[type=checkbox]', el)

    equal checks.length, 2, 'should have 2 emails to check'

    click checks.first()

    click $F('.multiple-todos')

    waitForSelector '.radium-form', (el) ->
      fillIn '#description', 'a  todo'

      selectDropDownOption('#assigned-to', 0)

      click $F('.save-todo')

      #FIXME better assertion needed.  Store is undefined at this point
      waitForSelector '.alert-success', (el) ->
        assertText el, 'created'

integrationTest 'the selected emails can be deleted', ->
  for i in [0..2]
    Factory.create 'email'

  emails = Radium.Email.find()

  equal emails.get('length'), 3, 'precond - there are 3 emails'

  visit '/inbox'

  waitForSelector 'ul.messages', (el) ->
    checks = $F('input[type=checkbox]', el)

    equal checks.length, 3, 'should have 3 emails to check'

    for i in [0..1]
      click checks.eq(i)

    click $F('.delete-emails')

    equal emails.get('length'), 1, 'both emails have been deleted'

    checks = $F('input[type=checkbox]', el)
    equal checks.length, 1, '1 email remains in sidebar'

integrationTest 'a list of recent messages from a sender can be displayed', ->
  bob = Factory.create 'user'
  frank = Factory.create 'user'

  [0..9].forEach (num) ->
    user = if num % 2 is 0 then bob else frank
    email1 = Factory.create 'email',
      sender:
        id: -> user
        type: 'user'

  emails = Radium.Email.find()

  equal emails.get('length'), 10, 'precond - there are 10 emails'

  visit '/inbox'

  waitForSelector 'ul.messages', (el) ->
    console.log 'wait'
