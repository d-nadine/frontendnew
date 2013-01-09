Radium = Em.Application.create
  autoinit: false
  rootElement: '#application'
  ready: ->
    @_super()
    # FIXME: Stub out authentication
    @set 'router.currentUser', Radium.User.find(1)

  didBecomeCompletelyReady: Ember.K
  didBecomeReady: ->
    @_super.apply @, arguments

    @didBecomeCompletelyReady()

window.Radium = Radium

require 'foundry'

require 'ember/datetime'
require 'ember/filterable_mixin'

require 'string/inflector'

require 'radium/lib/polymorphic'
require 'radium/lib/extended_record_array'
require 'radium/lib/clustered_record_array'
require 'radium/lib/filtered_array'
require 'radium/lib/groupable'
require 'radium/lib/limit_support'

require 'radium/store'

require 'radium/router'

require 'radium/feed'

require 'radium/mixins/views/slider'
require 'radium/mixins/views/time_picker'
require 'radium/mixins/infinite_scroller'
require 'radium/mixins/filtered_collection_mixin'
require 'radium/mixins/filtered_contacts_mixin'
require 'radium/mixins/validate'
require 'radium/mixins/form_validation'

require 'radium/helpers/date_helper'
require 'radium/helpers/time_helper'

require 'radium/models/comments_mixin'
require 'radium/models/core'
require 'radium/models/person'
require 'radium/models/contact'
require 'radium/models/group'
require 'radium/models/user'
require 'radium/models/todo'
require 'radium/models/account'
require 'radium/models/feed_section'
require 'radium/models/comment'
require 'radium/models/meeting'
require 'radium/models/deal'
require 'radium/models/message'
require 'radium/models/email'
require 'radium/models/phone_call'
require 'radium/models/gap'
require 'radium/models/notification'
require 'radium/models/reminder'
require 'radium/models/message'
require 'radium/models/invitation'

require 'radium/controllers/application_controller'
require 'radium/controllers/login_controller'
require 'radium/controllers/main_controller'
require 'radium/controllers/feed_controller'
require 'radium/controllers/topbar_controller'
require 'radium/controllers/inline_comments_controller'
require 'radium/controllers/users_controller'
require 'radium/controllers/contacts_controller'
require 'radium/controllers/deal_controller'
require 'radium/controllers/sidebar_controller'
require 'radium/controllers/form_controller'
require 'radium/controllers/meeting_form_controller'
require 'radium/controllers/contact_feed_controller'
require 'radium/controllers/user_feed_controller'
require 'radium/controllers/group_feed_controller'
require 'radium/controllers/calendar_feed_controller'
require 'radium/controllers/notifications_controller'
require 'radium/controllers/dashboard_feed_controller'

require 'radium/views/application_view'
require 'radium/views/login_view'
require 'radium/views/main_view'
require 'radium/views/feed_view'
require 'radium/views/feed_item_container_view'
require 'radium/views/todo_view_mixin'
require 'radium/views/feed_item_view'
require 'radium/views/topbar_view'
require 'radium/views/feed_details_container_view'
require 'radium/views/inline_comments_view'
require 'radium/views/comment_view'
require 'radium/views/feed_sections_list_view'
require 'radium/views/contacts_view'
require 'radium/views/label_view'
require 'radium/views/deal_view'
require 'radium/views/feed_items_list_view'
require 'radium/views/cluster_list_view'
require 'radium/views/cluster_item_view'
require 'radium/views/form_view'
require 'radium/views/date_picker_field'
require 'radium/views/todo_form_view'
require 'radium/views/sidebar_view'
require 'radium/views/calendar_sidebar_view'
require 'radium/views/gap_view'
require 'radium/views/feed_section_view'
require 'radium/views/feed_filter_item_view'
require 'radium/views/dashboard_feed_filter_view'
require 'radium/views/filtered_items_view'
require 'radium/views/form_container_view'
require 'radium/views/meeting_form_datepicker'
require 'radium/views/meeting_form_view'
require 'radium/views/calendar_feed_view'
require 'radium/views/calendar_view'
require 'radium/views/sidebar_meeting_form_view'
require 'radium/views/notifications_view'
require 'radium/views/notifications_link_view'
require 'radium/views/contacts_sidebar_view'
require 'radium/views/contacts_feed_filter_view'
require 'radium/views/contact_card_container_view'
require 'radium/views/contact_card_view'
require 'radium/views/contacts_toolbar_view'

require 'radium/factories'
