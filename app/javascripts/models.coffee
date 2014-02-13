require 'models/mixins/comments_mixin'
require 'models/mixins/attachments_mixin'
require 'models/mixins/timestamps_mixin'
require 'models/mixins/followable_mixin'
require 'models/mixins/has_tasks_mixin'

Radium.Model = DS.Model.extend Radium.TimestampsMixin,
  primaryKey: 'id'

  typeName: ( ->
    @constructor.toString().underscore().split('.').pop().toLowerCase()
  ).property()

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

requireAll /models/
