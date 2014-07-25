Radium.AddressbookUntrackedController = Ember.ArrayController.extend({
  searchText: "",
  filterParams: Ember.observer "searchText", ->
    #TODO: loading state
    @get("model").set("params", {private: true, like: @get("searchText")})

  actions:
    track: (model, status) ->
      # promote = Radium.PromoteExternalContact.createRecord
      #           externalContact: model
      #           status: status


      # promote.one 'didCreate', (result) =>
      #   @send "flashSuccess", "Contact created!"

      # @get('store').commit()
    destroy: (model) ->
      # @send 'animateDelete', model, =>
      #   name = model.get('displayName')

      #   model.deleteRecord()

      #   @get('store').commit()

      #   @send 'flashSuccess', "#{name} has been deleted."
})
