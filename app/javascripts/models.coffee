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

  delete: (context) ->
    self = this

    new Ember.RSVP.Promise (resolve, reject) ->
      self.deleteRecord()

      self.one 'didDelete', (result) ->
        resolve.call context, result

      self.addErrorHandlers(context, reject)

      self.get('store').commit()

  save: (context) ->
    self = this

    new Ember.RSVP.Promise (resolve, reject) ->
      success = (result) ->
        resolve result

      self.one 'didCreate', success
      self.one 'didUpdate', success

      self.addErrorHandlers(context, reject)

      self.get('store').commit()

  addErrorHandlers: (context, reject) ->
    @one 'becameInvalid', (result) ->
      result.reset() if result.get('id')
      context.send 'flashError', result
      reject result
      result.unloadRecord() unless result.get('id')

    @one 'becameError', (result) ->
      result.reset() if result.get('id')
      context.send 'flashError', 'An error has occurred and the operation could not be completed.'
      reject result
      result.unloadRecord() unless result.get('id')

  updateLocalBelongsTo: (key, belongsTo, notify = true) ->
    data = this.get('data')

    data[key] = {id: belongsTo.get('id'), type: belongsTo.constructor}

    @set('_data', data)

    return unless notify

    @suspendRelationshipObservers ->
      @notifyPropertyChange 'data'

    this.updateRecordArrays()

  updateLocalProperty: (property, value, notify = true) ->
    data = this.get('data')

    data[property] = value

    @set('_data', data)

    return unless notify

    @suspendRelationshipObservers ->
      @notifyPropertyChange 'data'

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
              "loaded.saved"
            else
              "loaded.created.uncommitted"

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
