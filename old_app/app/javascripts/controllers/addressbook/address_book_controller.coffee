require 'mixins/controllers/bulk_action_controller_mixin'

Radium.AddressbookController = Radium.ArrayController.extend Radium.BulkActionControllerMixin,
  actions:
    updateTotals: ->
      Radium.AddressbookTotals.find({}).then (results) =>
        totals = results.get('firstObject')

        @set 'contactsTotal', totals.get('contacts') || 0
        @set 'companiesTotal', totals.get('companies') || 0
        @set 'untrackedTotal', totals.get('untracked') || 0

        @set 'noContacts', totals.get('contacts') == 0

  noContacts: false
