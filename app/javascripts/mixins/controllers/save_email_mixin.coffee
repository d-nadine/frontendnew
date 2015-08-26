Radium.SaveEmailMixin = Ember.Mixin.create
  actions:
    saveEmail: (form, options) ->
      options = options || {}

      form.set 'isSubmitted', true

      return unless form.get('isValid')

      if options.bulkEmail
        return @send 'createBulkEmail', form, bulkEmailParams

      unless form.get('id')
        email = Radium.Email.createRecord form.get('data')
      else
        email = @get('model')
        email.setProperties form.get('data')

      isDraft = email.get('isDraft')

      email.set 'sentAt', Ember.DateTime.create()

      form.setFilesOnModel(email)

      if form.get('sendDraft')
        @send 'sendDraft', email
        return

      form.set('isSending', true) unless form.get('isDraft')

      queryParams =
        mode: 'single'
        from_people: false

      if template = @get('template')
        queryParams['template_id'] = template.get('id')

      self = this

      email.one 'didCreate', (result) =>
        Ember.run.next =>
          delete result.files
          result.off 'didUpdate'
          form.set 'isSubmitted', false
          form.set 'isSending', false
          Ember.run.next ->
            form?.reset(false)

            Ember.run.next ->
              if eventBus = self.EventBus
                self.EventBus.publish 'email:reset'

          messagesController = @getController('messages')

          unless options.dontAdd
            messagesController.tryAdd [email] unless messagesController.get('folder') == "inbox"

          if result.get('deal')
            result.get('deal').reloadAfterUpdate()

          if result.get('isDraft')
            folder = if result.get('isScheduled') then 'scheduled' else 'drafts'
            @send 'flashSuccess', "Email has been saved to the #{folder} folder"
            @getController('messagesSidebar').send 'reset'
            @getController('messages').set('selectedContent', result)

            return @getTransitionTo().call this, 'emails.edit', folder, result, queryParams: queryParams
          else
            return if options.dontTransition

          @getTransitionTo().call this, 'emails.sent', email

      email.one 'didUpdate', (result) =>
        Ember.run.next =>
          delete result.files
          form.set 'isSubmitted', false
          @send 'flashSuccess', 'Draft saved'
          @getTransitionTo().call(this, 'emails.edit', options.transitionFolder, result)  if options.transitionFolder

      email.one 'becameInvalid', =>
        form.set 'isSending', false
        @send 'flashError', email

      email.one 'becameError', =>
        form.set 'isSending', false
        @send 'flashError', 'An error has occurred and the email has not been sent'

      @store.commit()

    createBulkEmail: (form, bulkParams) ->
      form.set 'isSubmitted', true

      return unless form.get('isValid')

      job = Radium.BulkEmailJob.createRecord bulkParams

      job.setProperties form.get('data')

      form.setFilesOnModel(job)

      isScheduled = !!job.get('sendTime')

      job.save().then =>
        form.set 'isSubmitted', false
        unless isScheduled
          @send "flashSuccess", "The bulk email job has been created."
        else
          @send "flashSuccess", "The bulk email will be sent on #{job.sendTime.toHumanFormatWithTime()}"

        @getTransitionTo().call this, "people.index", "all", queryParams: bulkParams.returnParameters, customquery: '', hidesidebar: false

    addSignature: (signature) ->
      settings = @getController('userSettings').get('model')
      settings.set 'signature', signature

      settings.save().then =>
        @send 'flashSuccess', 'Signature updated'

  needs: ['contacts', 'users', 'userSettings', 'deals', 'peopleIndex', 'messages', 'messagesSidebar', 'templatesNew']

  settings: Ember.computed.alias 'controllers.userSettings.model'
  signature: Ember.computed.alias 'settings.signature'

  getTransitionTo: ->
    if this instanceof Ember.Controller || this instanceof Ember.ObjectController || this instanceof Ember.ArrayController
      @transitionToRoute
    else
      @transitionTo

  # UPGRADE: use inject
  getController: (controller) ->
    @container.lookup("controller:#{controller}")
