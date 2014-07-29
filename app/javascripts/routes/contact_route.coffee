Radium.ContactRoute = Radium.Route.extend
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

      contact.one 'becameInvalid', (result) ->
        result.reset() 

      contact.one 'becameError', (result) ->
        result.reset()

      addressBook = @controllerFor('addressbook').get('content')

      addressBook.removeObject(contact)

      @get('store').commit()

      @transitionTo 'addressbook.filter', 'people'

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
