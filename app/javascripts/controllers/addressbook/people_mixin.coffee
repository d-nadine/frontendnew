Radium.PeopleMixin = Ember.Mixin.create Ember.Evented,
  Radium.CheckableMixin,
  actions:
    trackAll: ->
      detail =
        jobType: Radium.BulkActionsJob
        modelType: Radium.Contact
        public: false
        private: true

      @send "executeActions", "track", detail
      false

    showMore: ->
      return if @get('content.isLoading')
      @get('model').expand()

      false

    switchShared: (contact) ->
      return if @get('isSaving')

      @set 'isSaving', false

      contact.toggleProperty('isPublic')

      contact.save().finally =>
        @set 'isSaving', false

      false

    saveEmail: (context) ->
      unless context.get('model.email')
        email = context.get('bufferedProxy.email')
        context.get('bufferedProxy').discardBufferedChanges()

        context.get('model.emailAddresses').createRecord
                         name: 'work'
                         value: email
                         isPrimary: true

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

      allChecked = if @get('isQuery')
                      @get('allChecked')
                   else
                      @get('allChecked') && !!!@get('potentialQueries.length')

      unless allChecked || checkedContent.length
        return @send 'flashError', "You have not selected any items."

      if action == "compose"
        return @transitionToRoute 'emails.new', "inbox", queryParams: mode: 'bulk', from_people: true

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

      if @get("isQuery")
        Ember.assert "you must have a customquery for an isQuery", @get('customquery')
        job.set 'customquery', @get('customquery')

      if @get('tag') && @get('isTagged')
        tag = Radium.Tag.all().find (t) => t.get('id') == @get('tag')
        job.set('tag', tag)

      if @get('user') && @get('isAssignedTo')
        user = Radium.User.all().find (u) => u.get('id') == @get('user')
        job.set 'user', user

      job.save().then( (result) =>
        @set 'working', false
        @send 'flashSuccess', 'The records have been updated.'
        Ember.run.once this, 'updateLocalRecords', job, detail
        @send 'updateTotals'
        @get('currentUser').reload()
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
          local = "localDelete"
          args = [model, dataset]
        else
          local = "local#{action.capitalize()}"
          args = [model, job]

        this[local].apply this, args

    @get('controllers.addressbook').send 'updateTotals'

  localTrack: (contact, dataset) ->
    contact.set 'isChecked', false
    Ember.run.next =>
      @get('model').removeObject contact

  localDelete: (model, dataset) ->
    dataset.removeObject model
    model.unloadRecord()

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

    Ember.assert "No newTagId found to update localTag", newTagId

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
    Ember.run.debounce this, @likeNessQuery, 300

  likeNessQuery: ->
    return if @get('filter') is null

    searchText = @get('searchText')

    filterParams = @get('filterParams') || {}

    params = Ember.merge filterParams, like: searchText, public: @get('public'), private: @get('private'), page_size: @get('pageSize')

    @get("content").set("params", Ember.copy(params))

  pageSize: 25
