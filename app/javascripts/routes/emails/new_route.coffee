require 'mixins/controllers/save_email_mixin'
require 'routes/mixins/send_email_mixin'

Radium.EmailsNewRoute = Ember.Route.extend  Radium.SaveEmailMixin, Radium.SendEmailMixin,
  queryParams:
    mode:
      refreshModel: true

  actions:
    willTransition: (transition) ->
      if transition.targetName == "messages.index"
        controller = @controllerFor('messages')
        @controllerFor('messagesSidebar').send 'reset'

        @transitionTo 'messages.index', transition.params.messages.folder

        return false

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
    return unless qps = transition.state.fullQueryParams

    if qps.from_people && !@controllerFor('peopleIndex').get('hasCheckedContent')
      @transitionTo 'people.index', 'all'

  model: (params) ->
    if params.mode = 'single'
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
    controller.get('model').reset()
    @controllerFor('messagesSidebar').send 'reset'

    peopleController = @controllerFor 'peopleIndex'
    peopleController.get('content').setEach 'isChecked', false
    peopleController.set 'searchText', ''
    peopleController.set 'allChecked', false

    @controllerFor('emailsNew').set 'mode', 'single'
