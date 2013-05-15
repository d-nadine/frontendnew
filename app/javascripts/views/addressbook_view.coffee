Radium.AddressBookView = Ember.View.extend
  classNames: ['page-view']
  layoutName: 'layouts/single_column'
  selectedFilterText: ( ->
    selectedFilter = if !@get('controller.model.selectedFilter') || @get('controller.model.selectedFilter') == 'initial'
                       'all'
                     else
                       @get('controller.model.selectedFilter')

    @get('controller.filters').findProperty('name', selectedFilter).text
  ).property('controller.model.selectedFilter')
