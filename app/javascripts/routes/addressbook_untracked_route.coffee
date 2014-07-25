Radium.AddressbookUntrackedRoute = Radium.Route.extend
  model: ->
    @dataset = Radium.InfiniteDataset.create
      type: Radium.Contact
      params: {private: true}
  actions:
    promote: (model, status) ->
      console.log 'I want to promote this', model, status
      promote = Radium.PromoteExternalContact.createRecord
                externalContact: model
                status: status

      addressBookController = @get('controllers.addressbook.model')

      promote.one 'didCreate', (result) =>
        @send "flashSuccess", "Contact created!"
        @get('content').removeObject(model)

      @get('store').commit()
    loadMoreContacts: ->
      console.log 'AddressbookUntrackedRoute.actions#loadMoreContacts'
      @dataset.expand()
