Radium.Route = Ember.Route.extend()

Radium.Router.reopen
  location: 'history'
  didTransition: (infos) ->
    @_super.apply this, arguments
    numberOfContacts =  Radium.Contact.all().filter((contact) => not contact.get('isPersonal')).get('length')
    window.Intercom('update', number_of_contacts: numberOfContacts)
    window.Intercom('reattach_activator')

Radium.Router.map ->
  @resource 'messages', path: '/messages/:folder', ->
    @route 'bulk_actions'
    @resource 'emails', ->
      @route 'show', path: '/:email_id'
      @route 'thread', path: '/:email_id/thread'
      @route 'empty', path: '/empty'
      @route 'new'
      @route 'edit', path: '/:email_id/edit'
      @route 'mailTo', path: 'mailto/:recipient_type/:recipient_id'
      # FIXME: this should be a routless state
      # The path is only here so the email can be
      # passed with transitionTo
      @route 'sent', path: '/:email_id/sent'

  @resource 'pipeline', ->
    @route 'index'
    @route 'workflow', path: '/:pipeline_state'
    @route 'closed'
    @route 'lost'
    @route 'opendeals'
    @route 'unpublished'
    @route 'resourceDeals', path: '/:resource_type/:resource_id/deals'

  @resource 'leads', ->
    @route 'new'
    @route 'import'
    @route 'match'
    @route 'fromCompany', path: '/new/companies/:company_id'

  @resource 'contacts'
  @resource 'contact', path: '/contacts/:contact_id'

  @resource 'company', path: '/companies/:company_id'

  @resource 'user', path: '/users/:user_id', ->
    @route 'form', path: '/:form'

  @resource 'tag', path: '/tags/:tag_id'

  @resource 'deals', ->
    @resource 'deal', path: '/:deal_id'
    @route 'new'
    @route 'fromContact', path: '/new/contacts/:contact_id'
    @route 'fromUser', path: '/new/users/:user_id'
    @route 'fromCompany', path: '/new/companies/:company_id'

  @resource 'calendar', ->
    @route 'index', path: '/:year/:month/:day'
    @route 'task', path: '/:task_type/:task_id'

  @resource 'addressbook', ->
    @route 'filter', path: '/:filter'
    @route 'assigned', path: '/users/:user_id/contacts'
    @route 'members', path: '/tags/:tag_id/members'
    @route 'employees', path: '/companies/:company_id/employees'
    @route 'contactimportjobs', path: '/contactimportjobs/:contact_import_job_id/contacts'

  @resource 'externalcontacts'

  @resource 'settings', ->
    @route 'profile'
    @route 'company'
    @route 'billing'
    @route 'api'
    @route 'customFields', path: 'custom-fields'
    @route 'leadSources', path: 'lead-sources'
    @route 'pipelineStates', path: 'pipeline-states'
    @route 'remindersAlerts', path: 'reminders-alerts'

  @route 'reports'
  
  @route 'unimplemented'
