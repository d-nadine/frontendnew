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

  route: Ember.computed ->
    @store.container.lookup('route:application')

  delete:  ->
    self = this
    route = @get('route')

    new Ember.RSVP.Promise (resolve, reject) ->
      self.deleteRecord()

      self.one 'didDelete', ->
        resolve.call self

      self.one 'becameError', ->
        route.send 'flashError', 'An error has occured and the deletion could not be completed.'

        reject.call self

      self.get('store').commit()

  save: ->
    self = this
    route = @get('route')

    new Ember.RSVP.Promise (resolve, reject) ->
      success = (result) ->
        resolve result

      self.one 'didCreate', success
      self.one 'didUpdate', success

      self.addErrorHandlers(reject)

      self.get('store').commit()

  addErrorHandlers: (reject) ->
    self = this
    @one 'becameInvalid', (result) ->
      route.send 'flashError', result

      reject result

      Ember.run.next ->
        if self.get('id')
          self.reset()
        else
          result.reset()
          result.unloadRecord()

    @one 'becameError', (result) ->
      self.reset() if self.get('id')
      route.send 'flashError', 'An error has occurred and the operation could not be completed.'
      reject result

      return if result.get('id')

      Ember.run.next ->
        result.reset()
        result.unloadRecord()

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
    @reload() if @get('id')

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
