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
        @transitionTo 'addressbook.filter', 'all'

      contact.one 'becameInvalid', (result) =>
        result.reset() 

      contact.one 'becameError', (result) =>
        result.reset() 

      @get('store').commit()

  renderTemplate: ->
    @render()
    @render 'contact/sidebar',
      into: 'contact'
      outlet: 'sidebar'
