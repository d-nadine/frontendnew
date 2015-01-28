require "controllers/addressbook/people_mixin"
require "controllers/leads/untracked_columns_config"

Radium.LeadsUntrackedController = Ember.ArrayController.extend Radium.PeopleMixin,
  Radium.UntrackedColumnsConfig,
  actions:
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
