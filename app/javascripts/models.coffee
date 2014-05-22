require 'models/mixins/comments_mixin'
require 'models/mixins/attachments_mixin'
require 'models/mixins/timestamps_mixin'
require 'models/mixins/followable_mixin'
require 'models/mixins/has_tasks_mixin'

Radium.PromiseProxy = Ember.ObjectProxy.extend Ember.PromiseProxyMixin,
  resolveContent: Ember.observer('promise', ->
    @then (result) => @set('content', result)
  ).on "init"

Radium.Model = DS.Model.extend Radium.TimestampsMixin,
  primaryKey: 'id'

  typeName: Ember.computed ->
    @constructor.toString().underscore().split('.').pop().toLowerCase()

  inErrorState: Ember.computed 'currentState.stateName', ->
    @get('currentState.stateName') == 'root.error'

  reset: ->
    state = if @get('id')
              'loaded.saved'
            else
              'loaded.created.uncommited'

    @get('transaction').rollback()
    @transitionTo(state)

  deleteRecord: ->
    if @get('currentState.stateName') != 'root.loaded.saved'
      return

    @send('deleteRecord')

  reloadAfterUpdateEvent: (event = 'didCreate') ->
    @one event, (result) ->
      @reloadAfterUpdate.call result

  reloadAfterUpdate: ->
    observer = ->
      if @get('currentState.stateName') == "root.loaded.saved"
        @removeObserver 'currentState.stateName', observer
        @reload()

    @addObserver 'currentState.stateName', observer

requireAll /models/
