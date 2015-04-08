Radium.LeadsImportRoute = Radium.Route.extend
  actions:
    confirmDeleteJob: (job) ->
      controller = @controllerFor 'contactImportJobConfirmation'
      controller.set 'model', job

      @render 'contact_import_job/deletion_confirmation',
        into: 'application'
        outlet: 'modal'
        controller: controller

    close: ->
      @render 'nothing',
        into: 'application'
        outlet: 'modal'

    deleteRecord: ->
      job = @controllerFor('contactImportJobConfirmation').get('model')

      job.deleteRecord()

      job.one 'didDelete', =>
        @send 'closeModal'

        @send 'flashSuccess', "The job has been deleted"

        Ember.run.later ->
          location.reload()
        , 200

      job.one 'becameInvalid', (result) =>
        @send 'flashError', result
        result.reset()

      job.one 'becameError', (result) =>
        result.reset()
        @send 'flashError', 'An error has occurred and the invitaiton cannot be sent.'

      @get('store').commit()

  model: ->
    Ember.RSVP.hash(
        contactImportJobs: Radium.ContactImportJob.find({}),
        customFields: Radium.CustomField.find({})
      )

  setupController: (controller, model) ->
    controller.set 'contactImportJobs', model.contactImportJobs
    customFieldMap = Ember.Map.create()

    model.customFields.forEach (field) ->
      customFieldMap.set field, Ember.Object.create(customField: field, value: '')

    controller.set 'customFieldMap', customFieldMap

    controller.set 'customFields', model.customFields.toArray().slice()

  deactivate: ->
    @controller.send 'reset'
    @controller.set 'importFile', null
