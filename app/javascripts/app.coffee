require 'radium/lib/store'
require 'radium/lib/transforms'

window.Radium = Em.Namespace.create
  createApp: ->
    app = Radium.App.create rootElement: $('#application')
    $.each Radium, (key, value) ->
      app[key] = value if value && value.isClass && key != 'constructor'

    @app   = app
    @store = app.store

Radium.App = Em.Application.extend
  initialize: ->
    router = Radium.Router.create()
    Radium.set('router', router)
    @_super(router)

  init: ->
    @_super()
    @store = DS.RadiumStore.create()
    @set('_api', $.cookie('user_api_key'))

$.ajaxSetup
  dataType: 'json'
  contentType: 'application/json'
  headers:
    'X-Radium-User-API-Key': Radium.get('_api')
    'Accept': 'application/json'

require 'radium/lib/inflector'
require 'radium/lib/polymorphic'
require 'radium/lib/expandable_record_array'
require 'radium/lib/extended_record_array'
require 'radium/lib/clustered_record_array'
require 'radium/lib/utils'
require 'radium/lib/filterable_mixin'
require 'radium/lib/filtered_array'
require 'radium/lib/groupable'
require 'radium/lib/limit_support'

require 'radium/router'

require 'radium/mixins/views/slider'
require 'radium/mixins/views/time_picker'
require 'radium/mixins/noop'
require 'radium/mixins/infinite_scroller'
require 'radium/mixins/filtered_collection_mixin'
require 'radium/mixins/validate'
require 'radium/mixins/form_validation'
require 'radium/mixins/nested_feed'
require 'radium/mixins/nested_feed_section'

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
require 'radium/models/call_list'
require 'radium/models/campaign'
require 'radium/models/message'
require 'radium/models/email'
require 'radium/models/phone_call'
require 'radium/models/sms'
require 'radium/models/gap'
require 'radium/models/contact_feed_section'
require 'radium/models/user_feed_section'
require 'radium/models/group_feed_section'
require 'radium/models/grouped_feed_section'
require 'radium/models/notification'
require 'radium/models/reminder'
require 'radium/models/message'
require 'radium/models/invitation'

require 'radium/controllers/application_controller'
require 'radium/controllers/me_controller'
require 'radium/controllers/login_controller'
require 'radium/controllers/main_controller'
require 'radium/controllers/feed_controller'
require 'radium/controllers/topbar_controller'
require 'radium/controllers/inline_comments_controller'
require 'radium/controllers/users_controller'
require 'radium/controllers/contacts_controller'
require 'radium/controllers/deal_controller'
require 'radium/controllers/campaign_controller'
require 'radium/controllers/sidebar_controller'
require 'radium/controllers/form_controller'
require 'radium/controllers/meeting_form_controller'
require 'radium/controllers/contacts_feed_controller'
require 'radium/controllers/users_feed_controller'
require 'radium/controllers/groups_feed_controller'
require 'radium/controllers/calendar_feed_controller'
require 'radium/controllers/notifications_controller'

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
require 'radium/views/campaign_view'
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
require 'radium/views/contacts_feed_view'
require 'radium/views/users_feed_view'
require 'radium/views/groups_feed_view'
require 'radium/views/calendar_feed_view'
require 'radium/views/calendar_view'
require 'radium/views/range_changer_view'
require 'radium/views/sidebar_meeting_form_view'
require 'radium/views/notification_item_view'
require 'radium/views/notifications_view'
require 'radium/views/notifications_link_view'

require 'radium/fixtures'
