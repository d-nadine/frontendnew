require "controllers/addressbook/people_mixin"
require "controllers/addressbook/untracked_columns_config"

Radium.AddressbookUntrackedController = Ember.ArrayController.extend Radium.PeopleMixin,
  Radium.UntrackedColumnsConfig,
  searchText: "",
  needs: ['addressbook']

  public: false
