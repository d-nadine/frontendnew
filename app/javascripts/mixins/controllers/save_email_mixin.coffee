Radium.SaveEmailMixin = Ember.Mixin.create
  actions:
    createBulkEmail: (form, bulkParams) ->
      form.set 'isSubmitted', true

      return unless form.get('isValid')

      job = Radium.BulkEmailJob.createRecord bulkParams

      job.setProperties form.get('data')

      form.setFilesOnModel(job)

      job.save(this).then =>
        form.set 'isSubmitted', false
        @send "flashSuccess", "The bulk email job has been created."
        @getTransitionTo().call this, "people.index", bulkParams.returnFilter, queryParams: bulkParams.returnParameters

    saveEmail: (form, options) ->
      options = options || {}

      form.set 'isSubmitted', true

      return unless form.get('isValid')

      if options.bulkEmail
        return @send 'createBulkEmail', form, bulkEmailParams

      unless form.get('id')
        email = Radium.Email.createRecord form.get('data')
      else
        email = @modelFor 'emailsEdit'
        email.setProperties form.get('data')

      isDraft = email.get('isDraft')

      email.set 'sentAt', Ember.DateTime.create()

      form.setFilesOnModel(email)

      if form.get('sendDraft')
        @send 'sendDraft', email
        return

      form.set('isSending', true) unless form.get('isDraft')

      email.one 'didCreate', (result) =>
        Ember.run.next =>
          delete result.files
          result.off 'didUpdate'
          form.set 'isSubmitted', false
          form.set 'isSending', false
          form.reset()

          messagesController = @getController('messages')

          messagesController.tryAdd [email] unless messagesController.get('folder') == "inbox"

          if result.get('deal')
            result.get('deal').reloadAfterUpdate()

          if result.get('isDraft')
            folder = if result.get('isScheduled') then 'scheduled' else 'drafts'
            @send 'flashSuccess', "Email has been saved to the #{folder} folder"
            @getController('messagesSidebar').send 'reset'
            @getController('messages').set('selectedContent', result)

            return @getTransitionTo().call this, 'emails.edit', folder, result
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

  getTransitionTo: ->
    if this instanceof Ember.Controller
      @transitionToRoute
    else
      @transitionTo

  getController: (controller) ->
    if this instanceof Ember.Controller
      @get("controllers.#{controller}")
    else
      @controllerFor(controller)
