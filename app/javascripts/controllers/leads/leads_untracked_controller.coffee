require "controllers/addressbook/people_mixin"
require "controllers/leads/untracked_columns_config"

Radium.UntrackedIndexController = Radium.ArrayController.extend Radium.PeopleMixin,
  Radium.PollerMixin,
  Radium.UntrackedColumnsConfig,
  actions:
    updateTotals: ->
      Radium.UntrackedContactsTotals.find({}).then (results) =>
        totals = results.get('firstObject')
        @set 'all', totals.get('all')
        @set 'filtered', totals.get('filtered')
        @set 'spam', totals.get('spam')

    deleteAll: ->
      detail =
        jobType: Radium.BulkActionsJob
        modelType: Radium.Contact
        public: false
        private: true

      @send "executeActions", "delete", detail

      @set "showDeleteConfirmation", false

      false

    confirmDeletion: ->
      unless @get('allChecked') || @get('checkedContent.length')
        return @flashMessenger.error "You have not selected any items."

      @set "showDeleteConfirmation", true

      false

    destroyContact: (contact)->
      contact.delete().then (result) =>
        @send "flashSuccess", "Contact deleted"

        dataset = @get('model')

        dataset.removeObject contact

        @get('addressbook').send 'updateTotals'

  searchText: "",
  needs: ['addressbook', 'peopleIndex']

  addressbook: Ember.computed.oneWay "controllers.addressbook"

  interval: 10000

  onPoll: ->
    currentUser = @get('currentUser')

    if currentUser.get('initialContactsImported')
      return @stop()
    else
      @start() unless @get('isPolling')

    @send "updateTotals"

    currentUser.one 'didReload', =>
      @container.lookup('route:untrackedIndex').refresh()

      return @stop() if currentUser.get('initialContactsImported')

    currentUser.reload()

  public: false
  private: true

  filter: null

  isFiltered: Ember.computed.equal 'filter', 'filtered'
  isAll: Ember.computed.equal 'filter', 'all'
  isSpam: Ember.computed.equal 'filter', 'spam'

  filterParams: Ember.computed 'filter', ->
    params =
      public: false
      private: true
      filter: @get('filter')

    params
