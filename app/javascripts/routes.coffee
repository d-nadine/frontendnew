Radium.Router.reopen
  location: 'history'

Radium.Router.map ->
  @resource 'messages', ->
    @route 'email', path: '/emails/:email_id'
    @route 'discussion', path: '/discussions/:discussion_id'
    @route 'bulk_actions'
    @resource 'emails', ->
      @route 'show', path: '/:email_id'
      @route 'new'
      # FIXME: this should be a routless state
      # The path is only here so the email can be 
      # passed with transitionTo
      @route 'sent', path: '/:email_id/sent'

  @resource 'pipeline', ->
    @route 'leads'
    @route 'negotiating'
    @route 'closed'
    @route 'lost'

  @resource 'leads', ->
    @route 'new'

  @resource 'contacts'

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
