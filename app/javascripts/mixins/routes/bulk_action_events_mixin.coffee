Radium.BulkActionEmailEventsMixin = Ember.Mixin.create
  events:
    sendEmail: (form) ->
      form.set 'isSubmitted', true
      return unless form.get('isValid')

      email = Radium.Email.createRecord form.get('data')

      email.set 'sender', @controllerFor('currentUser').get('model')

      @resetForm()

      @controllerFor('emailsSent').set('model', form)

      @store.commit()

      @render 'emails/sent',
        into: @getTemplate()
        outlet: 'confirmation'

    closeEmailConfirmation: ->
      template = if this.constructor == Radium.PipelineLeadsRoute then 'pipeline' else 'addressbook'

      @render 'nothing',
        into: @getTemplate()
        outlet: 'confirmation'

    reassign: (form) ->
      controller = @getController()
      reassignForm = controller.get('reassignForm')
      reassignForm.set('todo', @controller.get('reassignTodo'))
      reassignForm.commit().then =>
        controller.set('reassignTodo', null)
        reassignForm.reset()
        controller.trigger 'formReset'
        @resetForm()
        Radium.Utils.notify "Selected Items have been reassigned."

    confirmDeletion: ->
      @render 'bulk_actions/deletion_confirmation',
        into: 'application'
        outlet: 'modal'

    close: ->
      @render 'nothing',
        into: 'application'
        outlet: 'modal'

    confirmSingleDelete: (record) ->
      @controllerFor('bulkActionsSingleDeleteConfirmation').set('model', record)

      @render 'bulk_actions/single_delete_confirmation',
        into: 'application'
        outlet: 'modal'

    deleteRecord: (record) ->
      record.deleteRecord()

      Radium.Utils.notify "Record has been deleted."

      @send 'close'

    addTags: ->
      addTagsForm = @controller.get('addTagsForm')
      addTagsForm.addTags()

      @get('store').commit()
      addTagsForm.reset()

      @resetForm()
      Radium.Utils.notify "Selected tags added"

    confirmDeletion: ->
      @controllerFor('bulkActionsDeletionConfirmation').set('model', @getController().get('checkedContent'))
      @render 'bulk_actions/deletion_confirmation',
        into: 'application'
        outlet: 'modal'

    close: ->
      @render 'nothing',
        into: 'application'
        outlet: 'modal'

    deleteAll: ->
      @getController().get('checkedContent').toArray().forEach (record) ->
        record.deleteRecord()

      @get('store').commit()

      @send 'close'

    confirmSingleDelete: (record) ->
      @controllerFor('bulkActionsSingleDeleteConfirmation').set('model', record)

      @render 'bulk_actions/single_delete_confirmation',
        into: 'application'
        outlet: 'modal'

    deleteRecord: (record) ->
      record.deleteRecord()

      @send 'close'

  getController: ->
    if /addressbook/.test this.controller.constructor.toString()
      @controllerFor "addressbook"
    else
      this.controller

  getTemplate: ->
    if this.constructor == Radium.PipelineLeadsRoute then 'pipeline' else 'addressbook'

  resetForm: ->
    @getController().set 'activeForm', null
