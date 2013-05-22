Radium.BulkActionEmailEventsMixin = Ember.Mixin.create
  events:
    sendEmail: (form) ->
      form.set 'isSubmitted', true
      return unless form.get('isValid')

      email = Radium.Email.createRecord form.get('data')

      email.set 'sender', @controllerFor('currentUser').get('model')

      @resetForm()

      @controllerFor('emailsSent').set('model', form)

      @render 'emails/sent',
        into: @getTemplate()
        outlet: 'confirmation'

    closeEmailConfirmation: ->
      template = if this.constructor == Radium.PipelineLeadsRoute then 'pipeline' else 'addressbook'

      @render 'nothing',
        into: @getTemplate()
        outlet: 'confirmation'

    reassign: (form) ->
      reassignForm = @controller.get('reassignForm')
      reassignForm.set('todo', @controller.get('reassignTodo'))
      reassignForm.commit()
      @controller.set('reassignTodo', null)
      reassignForm.reset()
      @controller.trigger 'formReset'
      @resetForm()
      Radium.Utils.notify "Selected Items have been reassigned."

    addTags: ->
      addTagsForm = @controller.get('addTagsForm')
      addTagsForm.addTags()

      @get('store').commit()
      addTagsForm.reset()

      @resetForm()
      Radium.Utils.notify "Selected tags added"

  getTemplate: ->
    if this.constructor == Radium.PipelineLeadsRoute then 'pipeline' else 'addressbook'

  resetForm: ->
    controller = if this.constructor == Radium.PipelineLeadsRoute then 'pipelineLeads' else 'addressbook'
    @controllerFor(controller).set 'activeForm', null


