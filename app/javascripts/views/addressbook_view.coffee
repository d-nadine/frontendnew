require 'lib/radium/tag_autocomplete'
require 'mixins/views/bulk_action_view_mixin'

Radium.AddressbookView = Ember.View.extend Radium.BulkActionViewMixin,
  classNames: ['page-view']
  layoutName: 'layouts/single_column'

  didInsertElement: ->
    @_super.apply this, arguments
    @get('controller').on('selectedResourceChanged', this, 'onSelectedResourceChanged') if @get('controller').on

  onSelectedResourceChanged: (resource) ->
    @$('input[type=text]').val(resource.get('name')) if @$('input[type=text]')

  selectedFilterText: ( ->
    selectedFilter = @get('controller.model.selectedFilter')

    return 'All' unless selectedFilter

    return 'Companies' if selectedFilter == "resource" && @get('controller.model.selectedResource') instanceof Radium.Company
    return 'Tags' if selectedFilter == "resource" && @get('controller.model.selectedResource') instanceof Radium.Tag

    filter = @get('controller.filters').findProperty('name', selectedFilter)

    filter.text if filter
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
        when "addTags" then "Add Tags"
        else
          throw new Error("Unknown #{form} for bulkLeader")

    return result unless form == "assign"

    result += " to"
  ).property('controller.activeForm', 'controller.checkedContent.[]')

  tags: Radium.TagAutoComplete.extend
    sourceBinding: 'controller.addTagsForm.tags'
    placeholder: 'Add Tags'
