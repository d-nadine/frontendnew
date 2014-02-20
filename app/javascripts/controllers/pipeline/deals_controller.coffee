require 'controllers/pipeline/base_controller'
require 'controllers/pipeline/filter_mixin'

Radium.PipelineDealsController = Radium.PipelineBaseController.extend Radium.FilterMixin,
  actions:
    toggleChecked: ->
      allChecked = @get('checkedContent.length') == @get('length')

      @get('content').forEach (item) ->
        item.set 'isChecked', !allChecked

  init: ->
    @_super.apply this, arguments
    parentController = @get('parentController.parentController')
    return unless parentController instanceof Radium.PipelineIndexController
    Ember.bind(this, 'searchText', 'parentController.parentController.searchText')
    Ember.bind(this, 'selectedFilter', 'parentController.parentController.selectedFilter')

  resultsDidChange: ( ->
    unless parentController = @get('parentController')
      return

    return unless parentController instanceof Radium.WorkflowGroupItemController

    return if parentController.get("isDestroying")

    parentController.set('arrangedDealsLength', @get('length'))

    if @get('length')
      parentController.set('hide', false)
    else
      parentController.set('hide', true)
  ).observes('arrangedContent.[]', 'selectedFilter', 'searchText').on('init')

  sortContent: ->
    sort = @get("sort")

    @get("content").toArray().sort (a, b) ->
      Ember.compare a.get('displayName'), b.get('displayName')

  arrangedContent: ( ->
    content = @get('content')

    return Ember.A() unless content.get('length')

    searchText = @get('searchText')

    return @sortContent() unless searchText?.length

    selectedFilter = @get('selectedFilter')

    content.setEach 'isChecked', false

    content = content.filter (item) ->
                  if selectedFilter == 'name'
                    ~item.get('name').toLowerCase().indexOf(searchText.toLowerCase())
                  else if selectedFilter == 'company'
                    item.get('contact.company') && ~item.get('displayName').toLowerCase().indexOf(searchText.toLowerCase())
                  else
                    ~item.get(selectedFilter).get('displayName').toLowerCase().indexOf(searchText.toLowerCase())

    @sortContent()
  ).property('content.[]', 'selectedFilter', 'searchText', 'sort')

  dealValues: Ember.computed.mapBy 'visibleContent', 'value'
  total: Ember.computed.sum 'dealValues'
