Radium.Router.reopen
  location: 'history'

Radium.Router.map ->
  @resource 'messages', ->
    @route 'email', path: '/emails/:email_id'
    @route 'discussion', path: '/discussions/:discussion_id'
    @route 'bulk_actions'
    @route 'send'

  @resource 'pipeline', ->
    @route 'leads'
    @route 'negotiating'
    @route 'closed'
    @route 'lost'

  @resource 'contact', path: '/contacts/:contact_id'

  @resource 'user', path: '/users/:user_id'

  @resource 'deals', ->
    @resource 'deal', path: '/:deal_id'
    @route 'new'

  @resource 'calendar', path: '/:year/:month/:day'

  @route 'unimplemented'

  @resource 'development', ->
    @route 'forms'
    @route 'todoForm'
    @route 'callForm'
    @route 'meetingForm'
    @route 'discussionForm'
    @route 'emailForm'
    @route 'widgets'
