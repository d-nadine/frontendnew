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

      job.delete().then (result) =>
        @send 'closeModal'

        @send 'flashSuccess', "The job has been deleted"

        Ember.run.later ->
          location.reload()
        , 200

  model: ->
    Ember.RSVP.hash(
        contactImportJobs: Radium.ContactImportJob.find({}),
        customFields: Radium.CustomField.find({})
      )

  setupController: (controller, model) ->
    controller.set 'contactImportJobs', model.contactImportJobs

    customFieldMappings = model.customFields.map (f) ->
      Ember.Object.create field: f, mapping: ''

    controller.set 'customFieldMappings', customFieldMappings

    return unless model.contactImportJobs.get('length')

    contactImportJobs = model.contactImportJobs.toArray()

    sortedJobs = contactImportJobs.sort (a, b) ->
      left = b.get('createdAt') || Ember.DateTime.create()
      right = a.get('createdAt') || Ember.DateTime.create()
      Ember.DateTime.compare left, right

    firstJob = sortedJobs.get('firstObject')

    if firstJob.get('isProcessing')
      controller.pollForJob(firstJob)

  deactivate: ->
    @controller.send 'reset'
    @controller.set 'importFile', null
