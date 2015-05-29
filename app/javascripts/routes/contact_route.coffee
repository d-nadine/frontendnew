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

      name = contact.get('displayName')

      @send 'closeModal'

      contact.delete(this).then (result) =>
        @send 'flashSuccess', "The contact #{name} has been deleted"

        peopleDataset = @controllerFor('peopleIndex').get('model')

        peopleDataset.removeObject(contact) if peopleDataset

        @transitionTo 'people.index', 'all'

        addressbookController = @controllerFor('addressbook')
        addressbookController.send('updateTotals') if addressbookController

    saveEmail: (email) ->
      @_super email, dontTransition: true

      return unless email.get('isValid')

      @send 'flashSuccess', 'Email Sent!'

      false

    deleteFromEditor: ->
      @controllerFor('contact').trigger 'formChanged', 'todo'

  afterModel: (model, transition) ->
    controller = @controllerFor 'contact'

    new Ember.RSVP.Promise (resolve, reject) ->
      Radium.CustomField.find({}).then( (fields) ->
        controller.set 'customFields', fields

        customFieldMap = model.getCustomFieldMap(fields)

        model.set 'customFieldMap', customFieldMap

        resolve(model)
      ).catch (error) ->
        Ember.Logger.error(error)
        reject(model)

  setupController: (controller, model) ->
    ['todo'].forEach (form) ->
      if form = controller.get("formBox.#{form}Form")
        form?.reset()

    controller.set('model', model)

    if form = controller.get('form')
      Ember.run.next ->
        controller.trigger 'formChanged', form

  renderTemplate: ->
    @render()
    @render 'contact/sidebar',
      into: 'contact'
      outlet: 'sidebar'

  deactivate: ->
    @controller.set 'form', null
