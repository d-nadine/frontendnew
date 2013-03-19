Radium.Router.reopen
  location: 'history'

Radium.Router.map ->
  @route 'dashboard'

  @resource 'messages', ->
    @route 'email', path: '/emails/:email_id'
    @route 'discussion', path: '/discussions/:email_id'

  @resource 'pipeline', ->
    @route 'leads'
    @route 'negotiating'
    @route 'closed'
    @route 'lost'

  @resource 'contacts'

  @resource 'contact', path: '/contacts/:contact_id'

  @resource 'user', path: '/users/:user_id'

  @resource 'deal', path: '/deals/:deal_id'

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
