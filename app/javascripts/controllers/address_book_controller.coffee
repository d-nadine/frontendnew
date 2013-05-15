Radium.AddressBookController = Radium.ArrayController.extend
  lookupItemController: (model) ->
    "search.#{model.typeName()}"

  filters: [
    {name: 'all', text: 'All'}
    {name: 'assigned', text: 'Assigned To'}
    {name: 'lead', text: 'Lead'}
    {name: 'existing', text: 'Existing Customers'}
    {name: 'exclude', text: 'Excluded from Pipeline'}
    {name: 'companies', text: 'Companies'}
    {name: 'tags', text: 'Tags'}
  ]

  changeFilter: (filter) ->
    @set 'model.selectedFilter', filter
