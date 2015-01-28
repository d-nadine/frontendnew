Radium.PeopleMixin = Ember.Mixin.create Radium.CheckableMixin,
  actions:
    showMore: ->
      return if @get('content.isLoading')
      @get('model').expand()

    sort: (prop, ascending) ->
      model = @get("model")
      params = model.get("params")

      delete params.sort_properties
      sort_properties = "sort_properties": JSON.stringify([{"property": prop, "asc": ascending}])

      params = Ember.merge sort_properties, params

      model.set 'params', params
      false

    executeActions: (action, detail) ->
      checkedContent = @get('checkedContent')
      allChecked = @get('allChecked')

      unless allChecked || checkedContent.length
        return @send 'flashError', "You have not selected any items."

      if action == "compose"
        return @transitionToRoute 'emails.new', "inbox", queryParams: bulkEmail: true

      @set 'working', true

      unless allChecked
        ids = checkedContent.mapProperty('id')
        filter = null
      else
        ids = []
        filter = @get('filter')

      job = detail.jobType.createRecord
             action:  action
             ids: ids
             public: @get('public')
             private: @get('private')
             filter: filter

      searchText = $.trim(@get('searchText') || '')

      if searchText.length
        job.set 'like', searchText

      if action == "tag"
        job.set('newTags', Ember.A([detail.tag.id]))
      else if action == "assign"
        job.set('assignedTo', detail.user)
      else if action == "status"
        job.set('status', detail.status)

      if @get('tag') && @get('isTagged')
        tag = Radium.Tag.all().find (t) => t.get('id') == @get('tag')
        job.set('tag', tag)

      if @get('user') && @get('isAssignedTo')
        user = Radium.User.all().find (u) => u.get('id') == @get('user')
        job.set 'user', user

      job.save(this).then( (result) =>
        @set 'working', false
        @send 'flashSuccess', 'The records have been updated.'
        @send 'updateLocalRecords', job, detail
        @send 'updateTotals'
      ).catch =>
        @set 'working', false

    updateLocalRecords: (job, detail) ->
      ids = @get('checkedContent').mapProperty 'id'
      action = job.get('action')
      dataset = @get('model')

      for id in ids by -1
        model = detail.modelType.all().find (c) -> c.get('id') + '' == id

        if model
          if action == "delete"
            @send 'localDelete', model, dataset
          else
            localAction = "local#{action.capitalize()}"

            @send localAction, model, job

      @get('controllers.addressbook').send 'updateTotals'

    localDelete: (model, dataset) ->
      model.unloadRecord()
      dataset.removeObject model

    localAssign: (model, job) ->
      model.updateLocalBelongsTo 'user', job.get('assignedTo')

    localStatus: (model, job) ->
      model.updateLocalBelongsTo 'contactStatus', job.get('status')

    localTag: (model, job) ->
      data = model.get('_data')
      store = @get('store')
      serializer = @get('store._adapter.serializer')
      loader = DS.loaderFor(store)

      references = data.tags.map((tag) -> {id: tag.id, type: Radium.Tag})

      newTagId = job.get('newTags.firstObject')

      tag = Radium.Tag.all().find (t) -> t.get('id') == newTagId

      unless references.any((tag) -> tag.id == newTagId)
        references.push id: newTagId, type: Radium.Tag

      tagName = serializer.extractRecordRepresentation(loader, Radium.TagName, {name: tag.get('name')})

      tagName.parent = model.get('_reference')
      data.tagNames.push tagName

      references = model._convertTuplesToReferences(references)
      data['tags'] = references

      model.set('_data', data)

      model.suspendRelationshipObservers ->
        model.notifyPropertyChange 'data'

      model.updateRecordArrays()

  users: Ember.computed.oneWay 'controllers.users'

  totalRecords: Ember.computed 'content.source.content.meta', ->
    @get('content.source.content.meta.totalRecords')

  checkedTotal: Ember.computed 'totalRecords', 'checkedContent.length', 'allChecked', 'working', ->
    if @get('allChecked')
      @get('totalRecords')
    else
      @get('checkedContent.length')

  searchText: ""

  searchDidChange: Ember.observer "searchText", ->
    return if @get('filter') is null

    searchText = @get('searchText')

    filterParams = @get('filterParams') || {}

    params = Ember.merge filterParams, like: searchText, public: @get('public'), private: @get('private')

    @get("content").set("params", Ember.copy(params))
