Radium.AddressBookView = Ember.View.extend
  classNames: ['page-view']
  layoutName: 'layouts/single_column'
  selectedFilterText: ( ->
    selectedFilter = @get('controller.model.selectedFilter')

    return 'All' unless selectedFilter

    @get('controller.filters').findProperty('name', selectedFilter).text
  ).property('controller.model.selectedFilter')
