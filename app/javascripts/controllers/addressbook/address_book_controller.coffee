require 'lib/radium/show_more_mixin'
require 'mixins/controllers/bulk_action_controller_mixin'

Radium.AddressbookController = Radium.ArrayController.extend Radium.ShowMoreMixin,
  Radium.CheckableMixin,
  Radium.BulkActionControllerMixin,

  init: ->
    @_super.apply this, arguments
    @get('checkedContent').addArrayObserver(this)

  arrayWillChange:  (start, removeCount, addCount) ->
    @set 'activeForm', null

  arrayDidChange: (start, removeCount, addCount) ->
    null

  destroy: ->
    @_super.apply this, arguments
    @get('checkedContent').removeArrayObserver(this)

  filters: [
    {name: 'people', text: 'People'}
    {name: 'assigned', text: 'Assigned To'}
    {name: 'lead', text: 'Lead'}
    {name: 'existing', text: 'Existing Customers'}
    {name: 'exclude', text: 'Excluded from Pipeline'}
    {name: 'companies', text: 'Companies'}
    {name: 'tags', text: 'Tags'}
    {name: 'all', text: 'All'}
  ]

  changeFilter: (filter) ->
    @set('currentPage', 1)
    @set 'model.selectedFilter', filter

  hasContacts: ( ->
    checkedContent = @get('checkedContent')

    return unless checkedContent.get('length')

    checkedContent.some (item) ->
      item instanceof Radium.Contact
  ).property('checkedContent.[]')
