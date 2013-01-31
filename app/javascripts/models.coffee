require 'radium/models/mixins/comments_mixin'
require 'radium/models/mixins/attachments_mixin'
require 'radium/models/mixins/timestamps_mixin'
require 'radium/models/mixins/followable_mixin'

Radium.Model = DS.Model.extend Radium.TimestampsMixin,
  primaryKey: 'id'

requireAll /radium\/models/
