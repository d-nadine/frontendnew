module 'Integration -  Inbox'

integrationTest 'a list of emails is displayed in the inbox', ->
  expect(5)

  for i in [0..4]
    Factory.create 'email'

  equal Radium.Email.find().get('length'), 5, 'precond - there are 5 emails'

  app ->
    Radium.get('router').transitionTo('root.inbox.index')

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
  for i in [0..1]
    Factory.create 'email'

  equal Radium.Email.find().get('length'), 2, 'precond - there are 2 emails'

  app ->
    Radium.get('router').transitionTo('root.inbox.index')

  waitForSelector 'ul.messages', (el) ->
    sidebarEmails = $F('li', el)

    equal sidebarEmails.length, 2, 'precond - 2 emails in the sidebar'

    lastEmail = $F('li:last', el)

    ok !lastEmail.hasClass('active'), 'last email is not active'

    click(lastEmail.find('div:eq(0)'))

    waitForSelector 'div.email > div.well', (el) ->
      ok lastEmail.hasClass('active'), 'last email is active'

      subject = $F('strong:eq(1)', el).html()
      equal 'Email 2', subject, 'Correct email is displayed'

