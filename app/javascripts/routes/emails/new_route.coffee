Radium.EmailsNewRoute = Ember.Route.extend
  actions:
    sendEmail: (form) ->
      form.set 'isSubmitted', true
      return unless form.get('isValid')

      form.set 'isSending', true

      email = Radium.Email.createRecord(form.get('data'))
      email.set('_senderUser', @controllerFor('currentUser').get('model'))

      formData = new FormData()
      formData.append('email', JSON.stringify(email.serialize()))

      files = form.get('data').files

      if files.length 
        for i in [0...files.length]
          formData.append(files[i].name, files[i])

      self = this

      url = "#{@get('store._adapter.url')}/emails"

      settings =
        url: url
        type: "POST"
        contentType: false
        processData: false
        xhr: ->
          Ember.$.ajaxSettings.xhr()
        data: formData

      settings.success = (data) ->
        Ember.run null, resolve, data

      settings.error = (jqXHR, textStatus, errorThrown) ->
        Ember.run null, reject, jqXHR

      Ember.$.ajax settings

      # email.one 'didCreate', =>
      #   Ember.run.next =>
      #     form.set 'isSubmitted', false
      #     form.set 'isSending', false
      #     @transitionTo 'emails.sent', email

      # email.one 'becameInvalid', =>
      #   form.set 'isSending', false
      #   @send 'flashError', email

      # email.one 'becameError', =>
      #   form.set 'isSending', false
      #   @send 'flashError', 'An error has occurred and the email has not been sent'

      # @store.commit()

  deactivate: ->
    @controllerFor('emailsNew').get('newEmail').reset()
