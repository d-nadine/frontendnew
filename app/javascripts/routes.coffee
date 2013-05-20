Radium.Route = Ember.Route.extend()

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
      @route 'mailTo', path: 'mailto/:recipient_type/:recipient_id'
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
    @route 'fromCompany', path: '/new/companies/:company_id'

  @resource 'contacts'
  @resource 'contact', path: '/contacts/:contact_id'

  @resource 'company', path: '/companies/:company_id'

  @resource 'user', path: '/users/:user_id'

  @resource 'tag', path: '/tags/:tag_id'

  @resource 'deals', ->
    @resource 'deal', path: '/:deal_id'
    @route 'new'

  @resource 'calendar', path: '/:year/:month/:day'

  @resource 'addressbook'

  @route 'unimplemented'

  @resource 'development', ->
    @route 'forms'
    @route 'todoForm'
    @route 'callForm'
    @route 'meetingForm'
    @route 'discussionForm'
    @route 'emailForms'
    @route 'widgets'
    @route 'masterFeed'
