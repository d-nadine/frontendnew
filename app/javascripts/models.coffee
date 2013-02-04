require 'models/mixins/comments_mixin'
require 'models/mixins/attachments_mixin'
require 'models/mixins/timestamps_mixin'
require 'models/mixins/followable_mixin'

Radium.Model = DS.Model.extend Radium.TimestampsMixin,
  primaryKey: 'id'

requireAll /models/
