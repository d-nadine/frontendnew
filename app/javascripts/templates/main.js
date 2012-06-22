// Auth
minispade.require('radium/templates/auth/login');
minispade.require('radium/templates/auth/error_page');

// Global
minispade.require('radium/templates/global/profile');
minispade.require('radium/templates/global/users_list');
minispade.require('radium/templates/global/topbar');

// Feed
minispade.require('radium/templates/feed/date_filters');
minispade.require('radium/templates/feed/date_group');
minispade.require('radium/templates/feed/filter');
minispade.require('radium/templates/feed/comment');
minispade.require('radium/templates/feed/inline_comments');
minispade.require('radium/templates/feed/feed_header_layout');
minispade.require('radium/templates/feed/cluster_item');


minispade.require('radium/templates/feed/scheduled/feed_meeting');
minispade.require('radium/templates/feed/scheduled/feed_deal');
minispade.require('radium/templates/feed/scheduled/feed_campaign');
minispade.require('radium/templates/feed/scheduled/feed_call_list');
minispade.require('radium/templates/feed/scheduled/feed_todo');
minispade.require('radium/templates/feed/scheduled/feed_todo_campaign');
minispade.require('radium/templates/feed/scheduled/feed_todo_deal');
minispade.require('radium/templates/feed/scheduled/feed_todo_email');
minispade.require('radium/templates/feed/scheduled/feed_todo_group');
minispade.require('radium/templates/feed/scheduled/feed_todo_phone_call');
minispade.require('radium/templates/feed/scheduled/feed_todo_contact');
minispade.require('radium/templates/feed/scheduled/feed_todo_sms');

minispade.require('radium/templates/feed/historical/todo_scheduled_for');
minispade.require('radium/templates/feed/historical/todo_created');
minispade.require('radium/templates/feed/historical/todo_assigned');
minispade.require('radium/templates/feed/historical/todo_finished');
minispade.require('radium/templates/feed/historical/deal_assigned');
minispade.require('radium/templates/feed/historical/deal_closed');
minispade.require('radium/templates/feed/historical/deal_created');
minispade.require('radium/templates/feed/historical/deal_followed');
minispade.require('radium/templates/feed/historical/deal_paid');
minispade.require('radium/templates/feed/historical/deal_pending');
minispade.require('radium/templates/feed/historical/deal_rejected');
minispade.require('radium/templates/feed/historical/campaign_created');
minispade.require('radium/templates/feed/historical/campaign_assigned');
minispade.require('radium/templates/feed/historical/campaign_contact_added');
minispade.require('radium/templates/feed/historical/campaign_contact_removed');
minispade.require('radium/templates/feed/historical/campaign_followed');
minispade.require('radium/templates/feed/historical/contact_assigned');
minispade.require('radium/templates/feed/historical/contact_became_customer');
minispade.require('radium/templates/feed/historical/contact_became_dead_end');
minispade.require('radium/templates/feed/historical/contact_became_lead');
minispade.require('radium/templates/feed/historical/contact_became_opportunity');
minispade.require('radium/templates/feed/historical/contact_became_prospect');
minispade.require('radium/templates/feed/historical/contact_created');
minispade.require('radium/templates/feed/historical/contact_followed');
minispade.require('radium/templates/feed/historical/invitation_created');

minispade.require('radium/templates/feed/historical/meeting_cancelled');
minispade.require('radium/templates/feed/historical/meeting_confirmed');
minispade.require('radium/templates/feed/historical/meeting_created');
minispade.require('radium/templates/feed/historical/meeting_rejected');
minispade.require('radium/templates/feed/historical/meeting_rescheduled');
minispade.require('radium/templates/feed/historical/meeting_scheduled_for');

minispade.require('radium/templates/feed/historical/message_created');

minispade.require('radium/templates/feed/historical/note_created');

minispade.require('radium/templates/feed/historical/phone_call_created');

minispade.require('radium/templates/feed/historical/sms_sent');

minispade.require('radium/templates/feed/historical/call_list_created');
minispade.require('radium/templates/feed/historical/call_list_scheduled_for');

minispade.require('radium/templates/feed/historical/email_sent');

//TODO: Check functionality of new templates
minispade.require('radium/templates/feed/historical/phone_call_made');
minispade.require('radium/templates/feed/historical/deal_scheduled_for');
minispade.require('radium/templates/feed/historical/campaign_scheduled_for');

minispade.require('radium/templates/feed/details/details_layout');
minispade.require('radium/templates/feed/details/todo_details');
minispade.require('radium/templates/feed/details/meeting_details');
minispade.require('radium/templates/feed/details/deal_details');
minispade.require('radium/templates/feed/details/campaign_details');
minispade.require('radium/templates/feed/details/call_list_details');

// Forms
minispade.require('radium/templates/forms/form_layout');
minispade.require('radium/templates/forms/fieldset');
minispade.require('radium/templates/forms/reminder');
minispade.require('radium/templates/forms/call_list_form');
minispade.require('radium/templates/forms/add_to_call_list');
minispade.require('radium/templates/forms/deal_form');
minispade.require('radium/templates/forms/discussion_form');
minispade.require('radium/templates/forms/meeting_form');
minispade.require('radium/templates/forms/message_form');
minispade.require('radium/templates/forms/contact_form');
minispade.require('radium/templates/forms/contacts_message_form');
minispade.require('radium/templates/forms/contacts_sms_form');
minispade.require('radium/templates/forms/todo_form');
minispade.require('radium/templates/forms/campaign_form');
minispade.require('radium/templates/forms/add_to_campaign_form');
minispade.require('radium/templates/forms/company_form');
minispade.require('radium/templates/forms/group_form');
minispade.require('radium/templates/forms/add_to_group');
minispade.require('radium/templates/forms/add_to_company');

// Edit forms
minispade.require('radium/templates/forms/edit/call_list_edit');
minispade.require('radium/templates/forms/edit/campaign_edit');
minispade.require('radium/templates/forms/edit/deal_edit');
minispade.require('radium/templates/forms/edit/meeting_edit');
minispade.require('radium/templates/forms/edit/todo_edit');

// Dashboard
minispade.require('radium/templates/dashboard/announcements');

// Notifications
minispade.require('radium/templates/dashboard/notification_item');
minispade.require('radium/templates/dashboard/notifications');
minispade.require('radium/templates/notifications/approved.following_notification');
minispade.require('radium/templates/notifications/cancelled.meeting_notification');
minispade.require('radium/templates/notifications/confirmed.meeting_notification');
minispade.require('radium/templates/notifications/invited.meeting_notification');
minispade.require('radium/templates/notifications/new.lead_notification');
minispade.require('radium/templates/notifications/rejected.meeting_notification');
minispade.require('radium/templates/notifications/requested.following_notification');
minispade.require('radium/templates/notifications/rescheduled.meeting_notification');

// Contacts
minispade.require('radium/templates/contacts/contacts');
minispade.require('radium/templates/contacts/contact');
minispade.require('radium/templates/contacts/contact_card');
minispade.require('radium/templates/contacts/lead');

// Users
minispade.require('radium/templates/users/users');
minispade.require('radium/templates/users/user');

// Deals
minispade.require('radium/templates/deals/overdue_deals');
minispade.require('radium/templates/deals/deals');

// Pipeline
minispade.require('radium/templates/pipeline/pipeline');

// Campaigns
minispade.require('radium/templates/campaigns/campaigns');
minispade.require('radium/templates/campaigns/campaign');

// Todos

minispade.require('radium/templates/ui/inline_textarea');
minispade.require('radium/templates/ui/inline_textfield');
minispade.require('radium/templates/ui/inline_select');
minispade.require('radium/templates/ui/inline_datepicker');
minispade.require('radium/templates/ui/token');

// nav
minispade.require('radium/templates/layouts/main_dash');
minispade.require('radium/templates/nav/dashboard_sidebar');
minispade.require('radium/templates/nav/contacts_sidebar');
minispade.require('radium/templates/nav/group_sidebar');

// feed
minispade.require('radium/templates/feed/dashboard_feed');
minispade.require('radium/templates/feed/date_section_header');
minispade.require('radium/templates/feed/scheduled_activity_feed');
minispade.require('radium/templates/feed/group_feed');

