require 'lib/radium/tag_autocomplete'
require 'mixins/views/bulk_action_view_mixin'

Radium.AddressbookView = Ember.View.extend Radium.BulkActionViewMixin,
  Radium.ScrollTopMixin,

  actions:
    showAddCompany: ->
      @get('controller').send 'setupNewCompany'
      @$('.address-book-controls').slideUp('medium', =>
        @$('.new-company').slideDown('medium', =>
          Ember.$('.new-company input[type=text]').focus()
        )
      )

  classNames: ['page-view']
  layoutName: 'layouts/single_column'

  didInsertElement: ->
    @_super.apply this, arguments
    @get('controller').on('selectedResourceChanged', this, 'onSelectedResourceChanged') if @get('controller').on

  onSelectedResourceChanged: (resource) ->
    @$('input[type=text]').val(resource.get('name')) if @$('input[type=text]')

  selectedFilterText: ( ->
    additionalFilter = @get('controller.model.additionalFilter')

    return 'Filter' unless additionalFilter

    filter = @get('controller.filters').findProperty('name', additionalFilter)
    filter.text if filter
  ).property('controller.model.additionalFilter')

  bulkLeader: ( ->
    form = @get('controller.activeForm')
    return unless form

    length = @get('controller.checkedContent.length')

    result =
      switch form
        when "assign" then "Reassign "
        when "todo" then "Add a Todo"
        when "call" then "Create and Assign a Call"
        when "email" then "Email "
        when "addTags" then "Add Tags"
        else
          throw new Error("Unknown #{form} for bulkLeader")

    return result unless form == "assign"

    result += " to"
  ).property('controller.activeForm', 'controller.checkedContent.[]')

  tags: Radium.TagAutoComplete.extend
    sourceBinding: 'controller.addTagsForm.tagNames'
    placeholder: 'Add Tags'

  searchInput: Ember.TextField.extend
    keyDown: (e) ->
      unless e.keyCode == 13
        @_super.apply this, arguments
        return

      e.preventDefault()
      e.stopPropagation()
