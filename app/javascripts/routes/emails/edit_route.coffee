require 'mixins/controllers/save_email_mixin'

Radium.EmailsEditRoute = Radium.Route.extend Radium.SaveEmailMixin,
  actions:
    deleteFromEditor: ->
      messagesController = @controllerFor('messages')

      folder = messagesController.get('folder')

      email = @modelFor('emailsEdit')

      messagesController.removeObject(email) if folder == 'drafts'

      @send 'delete', email

      @controllerFor('messagesSidebar').send 'reset'
      @transitionTo 'messages', messagesController.get('folder')

      false

  afterModel: (model, transition) ->
    emailForm = Radium.DraftEmailForm.create()
    emailForm.reset()

    emailForm.setProperties
      id: model.get('id')
      reference: model
      subject: model.get('subject')
      message: model.get('message')
      isDraft: true
      to: model.get('toList')
      cc: model.get('ccList').map (person) -> person.get('email')
      bcc: model.get('bccList').map (person) -> person.get('email')
      files: model.get('attachments').map (attachment) -> Ember.Object.create(attachment: attachment)
      bucket: model.get('bucket')
      sendTime: model.get('sendTime')
      checkForResponse: model.get('checkForResponse')
      deal: model.get('deal')

    @controllerFor('emailsEdit').set('emailForm', emailForm)
