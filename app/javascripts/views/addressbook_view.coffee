require 'mixins/views/bulk_action_view_mixin'

Radium.AddressbookView = Ember.View.extend Radium.BulkActionViewMixin,
  classNames: ['page-view']
  layoutName: 'layouts/single_column'

  selectedFilterText: ( ->
    selectedFilter = @get('controller.model.selectedFilter')

    return 'All' unless selectedFilter

    @get('controller.filters').findProperty('name', selectedFilter).text
  ).property('controller.model.selectedFilter')


  bulkLeader: ( ->
    form = @get('controller.activeForm')
    return unless form

    length = @get('controller.checkedContent.length')

    result =
      switch form
        when "assign" then "reassign "
        when "todo" then "add a todo"
        when "call" then "create and assign a call"
        when "email" then "email "
        else
          throw new Error("Unknown #{form} for bulkLeader")

    return result unless form == "assign"

    result += " to"
  ).property('controller.activeForm', 'controller.checkedContent.[]')
