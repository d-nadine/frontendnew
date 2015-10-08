require 'mixins/controllers/save_email_mixin'
require 'routes/mixins/send_email_mixin'
require 'mixins/templates_fields_promise'

Radium.EmailsNewRoute = Ember.Route.extend Radium.SaveEmailMixin,
  Radium.SendEmailMixin,
  Radium.TemplatesFieldsPromise,
  queryParams:
    mode:
      refreshModel: true

  actions:
    willTransition: (transition) ->
      if transition.targetName == "messages.index"
        @controllerFor('messagesSidebar').send 'reset'

      true

    deleteFromEditor: ->
      @controllerFor('messagesSidebar').send 'reset'
      Ember.run.next =>
        controller = @controllerFor('emailsNew')
        if controller.get('isBulkEmail')
          return @transitionTo 'people.index', 'all'

        @transitionTo 'messages', @controllerFor('messages').get('folder')

  newEmail: Radium.EmailForm.create()
  bulkEmail: Radium.BulkEmailForm.create()

  beforeModel: (transition) ->
    qps = transition.state.fullQueryParams || {}

    if qps.from_people && !@controllerFor('peopleIndex').get('hasCheckedContent')
        return @replaceWith 'people.index', 'all'

    @templatesFiledsPromise("emailsNew")

  model: (params) ->
    if bulkForm = @controllerFor('emailsNew').get('bulkForm')
      return bulkForm

    if params.mode == 'single'
      model = @newEmail
    else
      model = @bulkEmail

    model.reset()

    return model unless params.from_people

    controller = @controllerFor('peopleIndex')

    to = controller.get('checkedContent').map (item) ->
           Ember.Object.create
             id: item.get('id')
             type: 'contact'
             person: item
             name: item.get('name')
             email: item.get('email')
             avatarKey: item.get('avatarKey')
             displayName: item.get('displayName')
             source: item.get('source')

    model.set 'to', to

    model.set 'totalRecords', controller.get('checkedTotal')

    model

  deactivate: ->
    controller = @controllerFor('emailsNew')
    controller.set 'template', null
    controller.get('model').reset()
    controller.set('isSubmitted', false)
    @controllerFor('messagesSidebar').send 'reset'

    peopleController = @controllerFor 'peopleIndex'

    @controllerFor('emailsNew').setProperties
      mode: 'single'
      bulkForm: null
      form: null
      bulkParams: null
