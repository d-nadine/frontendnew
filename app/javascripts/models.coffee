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

  reload: ->
    return unless @get('inCleanState')

    @_super.apply this, arguments

  typeName: Ember.computed ->
    @constructor.toString().underscore().split('.').pop().toLowerCase()

  inErrorState: Ember.computed 'currentState.stateName', ->
    @get('currentState.stateName') == 'root.error'

  inCleanState: Ember.computed 'currentState.stateName', ->
    @get('currentState.stateName') == "root.loaded.saved"

  reset: ->
    state = if @get('id')
              'loaded.saved'
            else
              'loaded.created.uncommited'

    @get('transaction').rollback()
    @transitionTo(state)

  deleteRecord: ->
    unless @get('inCleanState')
      return

    @send('deleteRecord')

  reloadAfterUpdateEvent: (event = 'didCreate') ->
    @one event, (result) ->
      @reloadAfterUpdate.call result

  reloadAfterUpdate: ->
    observer = ->
      if @get('inCleanState')
        @removeObserver 'currentState.stateName', observer
        @reload()

    @addObserver 'currentState.stateName', observer

requireAll /models/
