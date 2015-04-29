require 'mixins/controllers/save_email_mixin'
require 'mixins/controllers/save_template_mixin'

Radium.EmailsEditRoute = Radium.Route.extend Radium.SaveEmailMixin,
  Radium.SaveTemplateMixin,

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
    queryParams = transition.queryParams

    props =
      mode: queryParams.mode || "single"
      from_people: queryParams.from_people || false

    if template_id = queryParams.template_id
      @template = Radium.Template.find template_id

    @controllerFor('emailsEdit').setProperties props

    emailForm = Radium.DraftEmailForm.create()
    emailForm.reset()

    emailForm.setProperties
      id: model.get('id')
      reference: model
      subject: model.get('subject')
      html: model.get('html')
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

  deactivate: ->
    @set 'template', null
