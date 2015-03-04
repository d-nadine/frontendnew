require 'mixins/controllers/save_email_mixin'

Radium.ContactRoute = Radium.Route.extend Radium.SaveEmailMixin,
  actions:
    confirmDeletion: ->
      @render 'contact/deletion_confirmation',
        into: 'application'
        outlet: 'modal'

    close: ->
      @render 'nothing',
        into: 'application'
        outlet: 'modal'

    deleteRecord: ->
      contact = @modelFor 'contact'

      contact.deleteRecord()

      name = contact.get('displayName')

      contact.one 'didDelete', =>
        @send 'closeModal'

        @send 'flashSuccess', "The contact #{name} has been deleted"

        peopleDataset = @controllerFor('peopleIndex').get('model')

        peopleDataset.removeObject(contact) if peopleDataset

        @transitionTo 'people.index', 'all'

        addressbookController = @controllerFor('addressbook')
        addressbookController.send('updateTotals') if addressbookController

      contact.one 'becameInvalid', (result) ->
        result.reset()

      contact.one 'becameError', (result) ->
        result.reset()

      @get('store').commit()

    saveEmail: (email) ->
      @_super email, dontTransition: true
      @send 'flashSuccess', 'Email Sent!'
      false

    deleteFromEditor: ->
      @controllerFor('contact').trigger 'formChanged', 'todo'

  renderTemplate: ->
    @render()
    @render 'contact/sidebar',
      into: 'contact'
      outlet: 'sidebar'

  setupController: (controller, model) ->
    ['todo'].forEach (form) ->
      if form = controller.get("formBox.#{form}Form")
        form?.reset()

    controller.set('model', model)

    if form = controller.get('form')
      Ember.run.next ->
        controller.trigger 'formChanged', form

  deactivate: ->
    @controller.set 'form', null
