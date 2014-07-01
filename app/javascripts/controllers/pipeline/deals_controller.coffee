require 'controllers/pipeline/base_controller'

Radium.PipelineDealsController = Radium.PipelineBaseController.extend
  needs: ["pipelineIndex"]
  sort: 'name'
  sortAscending: true
  filterList: ["name", "contact.displayName", "user.displayName", "company.displayName"]
  searchText: Ember.computed.alias 'controllers.pipelineIndex.searchText'
  filterStartDate: Ember.computed.alias 'controllers.pipelineIndex.filterStartDate'
  filterEndDate: Ember.computed.alias 'controllers.pipelineIndex.filterEndDate'

  actions:
    toggleChecked: ->
      allChecked = @get('checkedContent.length') == @get('length')

      @get('content').forEach (item) ->
        item.set 'isChecked', !allChecked

    sortDeals: (column, ascending) ->
      Ember.run =>
        @set 'sort', column
        @set 'sortAscending', ascending
        @notifyPropertyChange 'sort'

  resultsDidChange: Ember.observer('arrangedContent.[]', 'searchText', ->
    parentController = @get("controllers.pipelineIndex")
    return if parentController.get("isDestroying")

    parentController.set('arrangedDealsLength', @get('length'))

    if @get('length')
      parentController.set('hide', false)
    else
      parentController.set('hide', true)
  ).on('init')

  sortFunc: (a, b) ->
    sort = @get('sort')
    sortAscending = @get('sortAscending')

    if sortAscending
      left = a
      right = b
    else
      left = b
      right = a

    if sort == 'nextTask'
      sortA = left.get('nextTask')
      sortB = right.get('nextTask')

      if !sortA && !sortB
        return 0
      else if !sortA && sortB
        return -1
      else if sortA && !sortB
        return 1

      return Ember.DateTime.compare sortA.get('time'), sortB.get('time')

    if sort in ["expectedCloseDate", "statusLastChangedAt", "updatedAt"]
      sortA = left.get(sort)
      sortB = right.get(sort)
      if sortA && sortB
        return Ember.DateTime.compare left.get(sort), right.get(sort)
      else if !sortA && !sortB
        return 0
      else if !sortA && sortB
        return -1
      else if sortA && !sortB
        return 1

    Ember.compare left.get(sort), right.get(sort)

  dateFilteredContent: Ember.computed 'content.[]', 'filterStartDate', 'filterEndDate', ->
    content = @get('content')

    content.filter (item) =>
      return true unless @get("filterStartDate")? and @get("filterEndDate")?
      closeDate = item.get("expectedCloseDate._ms")
      startDate = @get("filterStartDate").getTime()
      endDate = @get("filterEndDate").getTime()
      return !closeDate? || (startDate <= closeDate && closeDate <= endDate)

  arrangedContent: Ember.computed 'dateFilteredContent.[]', 'searchText', 'sort', 'sortAscending', ->
    content = @get('dateFilteredContent')
    sortFunc = @sortFunc.bind this

    return Ember.A() unless content.get('length')

    searchText = @get('searchText')

    return content.toArray().sort(sortFunc) unless searchText?.length

    content.setEach 'isChecked', false

    content = content.filter (item) =>
      regex = new RegExp(searchText, "i")
      @get("filterList").some (filter) ->
        regex.test(item.get(filter))

    content.toArray().sort(sortFunc)

  dealValues: Ember.computed.mapBy 'arrangedContent', 'value'
  total: Ember.computed.sum 'dealValues'
