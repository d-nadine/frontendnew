Radium.AddressBookController = Radium.ArrayController.extend
  lookupItemController: (model) ->
    "search.#{model.typeName()}"

  filters: [
    {name: 'all', text: 'All'}
    {name: 'assigned', text: 'Assigned To'}
    {name: 'people', text: 'People'}
    {name: 'companies', text: 'Companies'}
    {name: 'existing', text: 'Existing Customers'}
    {name: 'exclude', text: 'Excluded from Pipeline'}
  ]

  changeFilter: (filter) ->
    @set 'model.selectedFilter', filter
