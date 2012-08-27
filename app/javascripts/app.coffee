require 'radium/lib/store'
require 'radium/lib/transforms'

Radium = Em.Application.create
  store: DS.RadiumStore.create()
  init: ->
    @_super()
    @set('_api', $.cookie('user_api_key'))

window.Radium = Radium

$.ajaxSetup
  dataType: 'json'
  contentType: 'application/json'
  headers:
    "X-Radium-User-API-Key": Radium.get('_api')
    "Accept": "application/json"

require 'radium/lib/polymorphic'
require 'radium/lib/extended_record_array'
require 'radium/lib/clustered_record_array'

require 'radium/router'

require 'radium/states/error'

require 'radium/mixins/views/slider'
require 'radium/mixins/noop'

require 'radium/helpers/date_helper'
require 'radium/helpers/time_helper'

require 'radium/models/comments_mixin'
require 'radium/models/core'
require 'radium/models/todo'
require 'radium/models/account'
require 'radium/models/feed_section'
require 'radium/models/person'
require 'radium/models/user'
require 'radium/models/comment'
require 'radium/models/meeting'
require 'radium/models/deal'
require 'radium/models/call_list'
require 'radium/models/contact'
require 'radium/models/campaign'
require 'radium/models/message'
require 'radium/models/email'
require 'radium/models/group'
require 'radium/models/phone_call'
require 'radium/models/sms'

require 'radium/controllers/application_controller'
require 'radium/controllers/me_controller'
require 'radium/controllers/login_controller'
require 'radium/controllers/main_controller'
require 'radium/controllers/feed_controller'
require 'radium/controllers/topbar_controller'
require 'radium/controllers/inline_comments_controller'
require 'radium/controllers/user_controller'
require 'radium/controllers/contacts_controller'
require 'radium/controllers/contact_controller'
require 'radium/controllers/deal_controller'
require 'radium/controllers/campaign_controller'
require 'radium/controllers/group_controller'

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
require 'radium/views/user_view'
require 'radium/views/contacts_view'
require 'radium/views/contact_view'
require 'radium/views/label_view'
require 'radium/views/deal_view'
require 'radium/views/campaign_view'
require 'radium/views/group_view'
require 'radium/views/feed_items_list_view'
require 'radium/views/cluster_list_view'
require 'radium/views/cluster_item_view'

require 'radium/templates/feed/feed_todo'
require 'radium/templates/feed/feed_todo_deal'
require 'radium/templates/feed/feed_todo_contact'
require 'radium/templates/feed/feed_todo_campaign'
require 'radium/templates/feed/feed_todo_email'
require 'radium/templates/feed/feed_todo_group'
require 'radium/templates/feed/feed_todo_phone_call'
require 'radium/templates/feed/feed_todo_sms'
require 'radium/templates/feed/feed_todo_todo'
require 'radium/templates/feed/feed_meeting'
require 'radium/templates/feed/feed_deal'
require 'radium/templates/feed/feed_call_list'
require 'radium/templates/feed/feed_campaign'
require 'radium/templates/feed/details/todo_details'
require 'radium/templates/feed/details/meeting_details'
require 'radium/templates/feed/details/deal_details'
require 'radium/templates/feed/details/call_list_details'
require 'radium/templates/feed/details/campaign_details'

require 'radium/templates/topbar'
require 'radium/templates/inline_comments'
require 'radium/templates/comment'
require 'radium/templates/user'
require 'radium/templates/contacts'
require 'radium/templates/contact'
require 'radium/templates/deal'
require 'radium/templates/campaign'
require 'radium/templates/group'
require 'radium/templates/empty_feed'
require 'radium/templates/cluster_item'

require 'radium/templates/layouts/feed_item_layout'
require 'radium/templates/layouts/feed_item_details_layout'

require 'radium/fixtures'
