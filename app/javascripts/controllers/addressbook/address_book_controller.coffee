require 'mixins/controllers/bulk_action_controller_mixin'

Radium.AddressbookController = Radium.ArrayController.extend Radium.BulkActionControllerMixin,
  actions:
    updateTotals: ->
      Radium.AddressbookTotals.find({}).then (results) =>
        totals = results.get('firstObject')

        @set 'contactsTotal', totals.get('contacts')
        @set 'companiesTotal', totals.get('companies')
        @set 'untrackedTotal', totals.get('untracked')