define(function(require) {  
  require('order!jquery');
  require('order!jqueryUI');
  require('order!ember');
  require('order!datetime');
  require('order!data');
  require('order!router');
  
  var Radium = require('order!radium');
  
  require('order!helpers/date_helper');
  require('order!helpers/time_helper');

  require('order!mixins/jqueryui');
  
  require('order!controllers/announcements');
  require('order!controllers/app');
  require('order!controllers/users');
  require('order!controllers/contacts');
  require('order!controllers/resources');
  require('order!controllers/activity_date_groups');
  require('order!controllers/feed');
  
  require('order!models/core');
  require('order!models/comment');
  require('order!models/address');
  require('order!models/announcement');
  require('order!models/attachment');
  require('order!models/calllist');
  require('order!models/campaign');
  require('order!models/customfield');
  require('order!models/deal');
  require('order!models/email');
  require('order!models/emailaddr');
  require('order!models/following');
  require('order!models/group');
  require('order!models/im');
  require('order!models/invitation');
  require('order!models/lineitem');
  require('order!models/meeting');
  require('order!models/message');
  require('order!models/note');
  require('order!models/phonecall');
  require('order!models/phonenumber');
  require('order!models/product');
  require('order!models/reminder');
  require('order!models/sms');
  require('order!models/todo');
  require('order!models/contact');
  require('order!models/user');
  require('order!models/activity');
  require('order!models/activity_date_group');
  
  require('order!fixtures/main');
  
  require('order!views/checkbox');
  require('order!views/topbar');
  require('order!views/forms/todo_form');
  require('order!views/dashboard');
  require('order!views/filter_list');
  require('order!views/globalsearch');
  require('order!views/loginpane');
  require('order!views/profile');
  require('order!views/dashboard/activity_summary');
  
  require('order!states/main');
  
  require('order!core/routes');
  
  return Radium;
});