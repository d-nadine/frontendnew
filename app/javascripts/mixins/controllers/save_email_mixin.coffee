Radium.SaveEmailMixin = Ember.Mixin.create
  actions:
    createBulkEmail: (form, bulkParams) ->
      return unless form.get('message.length')

      controller = @container.lookup('controller:peopleIndex')

      retParams = user: bulkParams.user, tag: bulkParams.tag

      findRecord = (type, id) ->
        type.all().find (r) -> r.get('id') == id

      if controller.get('tag') && controller.get('isTagged')
        bulkParams.tag = findRecord(Radium.Tag, bulkParams.tag)
      else if controller.get('isAssignedTo') && user_id = controller.get('user')
        bulkParams.user = findRecord(Radium.User, bulkParams.user)

      job = Radium.BulkEmailJob.createRecord bulkParams

      job.setProperties form.get('data')

      form.setFilesOnModel(job)

      job.one "didCreate", =>
        @send "flashSuccess", "The bulk email job has been created."
        @transitionTo "people.index", bulkParams.filter, queryParams: retParams

      job.one "becameError", =>
        @send "flashError", "An error has occurred and the bulk email job could not be created."

      @get('store').commit()

    saveEmail: (form, options) ->
      options = options || {}

      form.set 'isSubmitted', true

      if options.bulkEmail
        return @send 'createBulkEmail', form, options.bulkEmailParams

      return unless form.get('isValid')

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
          messagesController = @controllerFor('messages')
          messagesController.tryAdd [email] unless messagesController.get('folder') == "inbox"
          if result.get('deal')
            result.get('deal').reloadAfterUpdate()

          if result.get('isDraft')
            folder = if result.get('isScheduled') then 'scheduled' else 'drafts'
            @send 'flashSuccess', "Email has been saved to the #{folder} folder"
            @controllerFor('messagesSidebar').send 'reset'
            @controllerFor('messages').set('selectedContent', result)
            @transitionTo 'emails.edit', folder, result
          else
            @transitionTo 'emails.sent', email

      email.one 'didUpdate', (result) =>
        Ember.run.next =>
          delete result.files
          form.set 'isSubmitted', false
          @send 'flashSuccess', 'Draft saved'
          @transitionTo 'emails.edit', options.transitionFolder, result if options.transitionFolder

      email.one 'becameInvalid', =>
        form.set 'isSending', false
        @send 'flashError', email

      email.one 'becameError', =>
        form.set 'isSending', false
        @send 'flashError', 'An error has occurred and the email has not been sent'

      @store.commit()


