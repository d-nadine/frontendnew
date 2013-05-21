Radium.AddressbookView = Ember.View.extend
  classNames: ['page-view']
  layoutName: 'layouts/single_column'

  selectedFilterText: ( ->
    selectedFilter = @get('controller.model.selectedFilter')

    return 'All' unless selectedFilter

    @get('controller.filters').findProperty('name', selectedFilter).text
  ).property('controller.model.selectedFilter')


  bulkLeader: ( ->
    checkedContent = @get('controller.checkedContent.length')

    return unless checkedContent

    "#{checkedContent} selected"
  ).property('controller.activeForm', 'controller.checkedContent.length')
