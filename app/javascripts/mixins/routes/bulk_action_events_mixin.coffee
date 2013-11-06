Radium.BulkActionEmailEventsMixin = Ember.Mixin.create
  actions:
    toggleChecked: ->
      controller = if @controller.constructor is Radium.PipelineWorkflowController
                     @controllerFor 'pipelineWorkflowDeals'
                   else
                     this.controller

      allChecked = controller.get('checkedContent.length') == controller.get('visibleContent.length')

      controller.get('visibleContent').forEach (item) ->
        item.set 'isChecked', !allChecked

    sendEmail: (form) ->
      form.set 'isSubmitted', true
      return unless form.get('isValid')

      email = Radium.Email.createRecord form.get('data')

      email.set 'sender', @controllerFor('currentUser').get('model')

      email.set 'sentAt', Ember.DateTime.create()

      form.set 'isSending', true

      @resetForm()

      @controllerFor('emailsSent').set('model', form)

      email.one 'didCreate', =>
        Ember.run.next =>
          form.set 'isSubmitted', false
          form.set 'isSending', false
          @transitionTo 'emails.sent', email

      email.one 'becameInvalid', =>
        form.set 'isSending', false
        @send 'flashError', email

      email.one 'becameError', =>
        form.set 'isSending', false
        @send 'flashError', 'An error has occurred and the eamil has not been sent'

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
      reassignForm.set('todo', controller.get('reassignTodo'))
      reassignForm.commit().then =>
        controller.set('reassignTodo', null)
        reassignForm.reset()
        controller.trigger 'formReset'
        @resetForm()
        @send "flashSuccess", "Selected Items have been reassigned.",
      (error) =>
        @send 'flashError', error

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

      @send "flashSuccess", "Record has been deleted."

      @send 'close'

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
      didDelete = (record) =>
        record.deleteRelationships() if record.deleteRelationships

      @getController().get('checkedContent').toArray().forEach (record) ->
        record.deleteRecord()

        record.one 'didDelete', didDelete

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
    if /addressbook/.test @controllerFor('application').get('currentPath')
      @controllerFor "addressbook"
    else if @controller.constructor is Radium.PipelineWorkflowController
      @controllerFor "pipelineWorkflowDeals"
    else
      this.controller

  getTemplate: ->
    if this.constructor == Radium.PipelineLeadsRoute then 'pipeline' else 'addressbook'

  resetForm: ->
    @getController().set 'activeForm', null
