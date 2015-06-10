require 'routes/mixins/send_email_mixin'

Radium.BulkActionEmailEventsMixin = Ember.Mixin.create Radium.SendEmailMixin,
  actions:
    toggleChecked: ->
      controller = if @controller.constructor is Radium.PipelineWorkflowController
                     @controllerFor 'pipelineWorkflowDeals'
                   else
                     this.controller

      allChecked = controller.get('checkedContent.length') == controller.get('visibleContent.length')

      content = if controller.hasOwnProperty('visibleContent')
                  @get('visibleContent')
                else
                  @get('content')

      content.forEach (item) ->
        item.set 'isChecked', !allChecked

    sendEmail: (form) ->
      @_super.apply this, arguments

      @render 'emails/sent',
        into: @getTemplate()
        outlet: 'confirmation'

      false

    closeEmailConfirmation: ->
      template = if this.constructor == Radium.PipelineLeadsRoute then 'pipeline' else 'addressbook'

      @render 'nothing',
        into: @getTemplate()
        outlet: 'confirmation'

    reassign: (form) ->
      controller = @getController()
      controller.set('isSubmitted', true)
      reassignForm = controller.get('reassignForm')
      reassignForm.set('todo', controller.get('reassignTodo'))

      return unless reassignForm.get('assignToUser')

      reassignForm.commit().then =>
        controller.set('reassignTodo', null)
        reassignForm.reset()
        controller.trigger 'formReset'
        @resetForm()
        controller.set('isSubmitted', false)
        @send "flashSuccess", "Selected Items have been reassigned.",
      (error) =>
        @send 'flashError', error
        controller.set('isSubmitted', false)

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

      addressBook = @controllerFor('addressbook').get('content')

      record.delete().then ->
        if item = addressBook.find((el) -> el == record)
          console.log "found item"
          addressBook.removeObject item

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
      @getController().get('checkedContent').toArray().forEach (record) ->
        record.set('isChecked', false)
        record.deleteRecord()

      @get('store').commit()

      @send 'close'

  getController: ->
    if /addressbook/.test @controllerFor('application').get('currentPath')
      @controllerFor "addressbook"
    else if @controller instanceof Radium.PipelineWorkflowController
      @controllerFor "pipelineWorkflowDeals"
    else
      this.controller

  getTemplate: ->
    if this.constructor == Radium.PipelineLeadsRoute then 'pipeline' else 'addressbook'

  resetForm: ->
    @getController().set 'activeForm', null
