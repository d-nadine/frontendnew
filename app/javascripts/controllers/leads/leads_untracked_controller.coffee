require "controllers/addressbook/people_mixin"
require "controllers/leads/untracked_columns_config"

Radium.UntrackedIndexController = Ember.ArrayController.extend Radium.PeopleMixin,
  Radium.UntrackedColumnsConfig,
  actions:
    updateTotals: ->
      Radium.UntrackedContactsTotals.find({}).then (results) =>
        totals = results.get('firstObject')
        @set 'all', totals.get('all')
        @set 'filtered', totals.get('filtered')
        @set 'spam', totals.get('spam')

    trackAll: ->
      detail =
        jobType: Radium.BulkActionsJob
        modelType: Radium.Contact
        public: false
        private: true

      @send "executeActions", "track", detail
      false

    deleteAll: ->
      detail =
        jobType: Radium.BulkActionsJob
        modelType: Radium.Contact
        public: false
        private: true

      @send "executeActions", "delete", detail
      false

    localTrack: (contact, dataset) ->
      @get('model').removeObject contact
      contact.set 'checked', false
      @get('controllers.peopleIndex.model').pushObject contact
      Ember.run.next ->
        contact.set 'isChecked', false

    track: (contact) ->
      track = Radium.TrackedContact.createRecord
                contact: contact

      track.one 'didCreate', (result) =>
        @send "flashSuccess", "Contact is now tracked in Radium"

        dataset = @get('model')

        dataset.removeObject(contact)

        @get('controllers.peopleIndex.model').pushObject contact

        @get('addressbook').send 'updateTotals'

      @store.commit()

    destroyContact: (contact)->
      contact.deleteRecord()

      contact.one 'didDelete', =>
        @send "flashSuccess", "Contact deleted"

        dataset = @get('model')

        dataset.removeObject contact

        @get('addressbook').send 'updateTotals'

      @store.commit()

  searchText: "",
  needs: ['addressbook', 'peopleIndex']

  addressbook: Ember.computed.oneWay "controllers.addressbook"

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
