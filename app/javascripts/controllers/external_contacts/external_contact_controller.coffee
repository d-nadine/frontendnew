Radium.ExternalcontactsController = Radium.ArrayController.extend Radium.InfiniteScrollControllerMixin,
  needs: ['addressbook']
  page: 1
  allPagesLoaded: false
  pageSize: 20
  loadingType: Radium.ExternalContact

  categories: Ember.computed.alias 'controllers.addressbook.categories'

  actions:
    promote: (model, status) ->
      promote = Radium.PromoteExternalContact.createRecord
                externalContact: model
                status: status

      existingDeals = Radium.Deal.all().slice()

      promote.one 'didCreate', (result) =>
        @send "flashSuccess", "Contact created!"
        @get('content').removeObject(model)
        if status == "pipeline" 
          Radium.Deal.find({}).then (deals) =>
            delta = deals.toArray().reject (record) =>
                      existingDeals.contains(record)

            deal = delta.get('firstObject')
            @get('controllers.addressbook.model').pushObject(deal.get('contact'))
            @set 'newPipelineDeal', deal

      @get('store').commit()

    reset: ->
      @set('page', 1)

  modelQuery: ->
    Radium.ExternalContact.find(@queryParams())

  queryParams: ->
    pageSize = @get('pageSize')
    userId = @get('currentUser.id')
    page = @get('page')

    page: page
    page_size: pageSize
    user_id: userId

  arrangedContent: ( ->
    @get('content').filter (item) -> item.get('name.length') || item.get('email.length')
  ).property('content.[]')

  hasNewPipelineDeal: ( ->
    @get('newPipelineDeal')
  ).property('newPipelineDeal')
