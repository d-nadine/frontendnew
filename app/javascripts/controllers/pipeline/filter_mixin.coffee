Radium.FilterMixin = Ember.Mixin.create
  actions:
    changeFilter: (filter) ->
      @set 'selectedFilter', filter

  selectedFilter: 'name'
  searchText: null
  sort: 'name'
  sortAscending: true

  selectedFilterText: ( ->
    @get('filters').findProperty('name', @get('selectedFilter')).text
  ).property('selectedFilter')

  filters: [
    {name: 'name', text: 'Filter By Name'}
    {name: 'contact', text: 'Filter By Contact'}
    {name: 'company', text: 'Filter By Company'}
    {name: 'user', text: 'Filter By Assigned'}
    {name: 'all', text: 'Filter By Any'}
  ]
