require 'models/mixins/comments_mixin'
require 'models/mixins/attachments_mixin'
require 'models/mixins/timestamps_mixin'
require 'models/mixins/followable_mixin'
require 'models/mixins/has_tasks_mixin'

Radium.Model = DS.Model.extend Radium.TimestampsMixin,
  primaryKey: 'id'

  typeName: ->
    @constructor.toString().split('.').pop().toLowerCase()

requireAll /models/

Radium.Model.reopenClass
  mappings:
    contacts: Radium.Contact
    users: Radium.User
    companies: Radium.Company

  keyFromValue: (klass) ->
    (for key of @mappings
      if @mappings[key] == klass
        return key)
