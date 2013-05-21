require 'lib/radium/show_more_mixin'

Radium.AddressbookController = Radium.ArrayController.extend Radium.ShowMoreMixin,
  Radium.CheckableMixin,

  filters: [
    {name: 'all', text: 'All'}
    {name: 'people', text: 'People'}
    {name: 'assigned', text: 'Assigned To'}
    {name: 'lead', text: 'Lead'}
    {name: 'existing', text: 'Existing Customers'}
    {name: 'exclude', text: 'Excluded from Pipeline'}
    {name: 'companies', text: 'Companies'}
    {name: 'tags', text: 'Tags'}
  ]

  checkAll: ->
    hasCheckedContent = !!@get('checkedContent.length')
    @get('visibleContent').setEach 'isChecked', !hasCheckedContent

  changeFilter: (filter) ->
    @set('currentPage', 1)
    @set 'model.selectedFilter', filter
