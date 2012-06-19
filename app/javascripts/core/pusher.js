Radium.Pusher = Ember.Object.create({
  pusher_appkey: 'cb6692235dd6e2afccbe',
  feedChannelEvents: ['update'],
  streamChannelEvents: ['created', 'Updated', 'deleted'],
  init: function(){
    Pusher.log = function log( msg ) {
      console.log(msg);
    };

    this.pusher = new Pusher(this.pusher_appkey);

    this.pusher.connection.bind('connected', function(){
      console.log('pusher connection ok');
    });

    var feedChannel = this.pusher.subscribe('feed-' + $.cookie('user_api_key'));

    feedChannel.bind('update', this.feedUpdate);

    var streamChannel = this.pusher.subscribe('stream-' + $.cookie('user_api_key'));

    streamChannel.bind('created', this.streamCreated);

    streamChannel.bind('updated', this.streamUpdated);
  },
  sendDummyPushes: function(){
    var events = [{"event":"created","data":{"meeting":{"id":24,"created_at":"2012-06-18T14:53:38Z","updated_at":
                    "2012-06-18T14:53:38Z","topic":"Yet Another meeting","location":"Location",
                    "starts_at":"2012-06-18T01:02:00Z","ends_at":"2012-06-18T01:02:00Z","meta":{},
                    "contacts":[],"users":[1082],
                    "invitations":[{"id":34,"created_at":"2012-06-18T14:53:38Z",
                    "updated_at":"2012-06-18T14:53:38Z","state":"confirmed",
                    "hash_key":"f11ed6ad40c9891558758fe852726198","meeting":24,"meta":{},
                    "comments":[],"invitee":{"user":1082}}],"attachments":[],"comments":[]}},"channel":"stream-feed_demo"},
                    {"event":"created","data":{"activity":{"id":56421,"created_at":"2012-06-18T14:53:38Z",
                    "updated_at":"2012-06-18T14:53:38Z","kind":"meeting","tag":"scheduled_for",
                    "scheduled":true,"timestamp":"2012-06-18T01:02:00Z","meta":{},"comments":[],"owner":null,
                    "reference":{"meeting":{"id":24,"created_at":"2012-06-18T14:53:38Z","updated_at":"2012-06-18T14:53:38Z",
                    "topic":"Yet Another meeting","location":"Location","starts_at":"2012-06-18T01:02:00Z",
                    "ends_at":"2012-06-18T01:02:00Z","meta":{},"contacts":[],"users":[1082],
                    "invitations":[{"id":34,"created_at":"2012-06-18T14:53:38Z","updated_at":"2012-06-18T14:53:38Z",
                    "state":"confirmed","hash_key":"f11ed6ad40c9891558758fe852726198",
                    "meeting":24,"meta":{},"comments":[],"invitee":{"user":1082}}],"attachments":[],"comments":[]}}}},
                    "channel":"stream-feed_demo"},
                    {"event":"created","data":{"activity":{"id":56423,"created_at":"2012-06-18T14:53:39Z",
                    "updated_at":"2012-06-18T14:53:39Z","kind":"invitation","tag":"created","scheduled":false,
                    "timestamp":"2012-06-18T14:53:38Z","meta":{},"comments":[],
                    "owner":{"user":{"id":1082,"created_at":"2012-06-14T16:02:47Z","updated_at":"2012-06-14T16:02:47Z",
                    "name":"Angela Marshall","email":"demo@feed-demo.com","phone":"127407572326",
                    "public":true,"meta":{"feed":{"start_date":"2012-05-14","end_date":"2013-06-14",
                    "current_date":"2012-06-14"}},"api_key":"feed_demo",
                    "avatar":{"small_url":"/images/fallback/small_default.png",
                    "medium_url":"/images/fallback/medium_default.png",
                    "large_url":"/images/fallback/large_default.png",
                    "huge_url":"/images/fallback/huge_default.png"},"account":27}},"reference":{"invitation":{"id":34,"created_at":"2012-06-18T14:53:38Z","updated_at":"2012-06-18T14:53:38Z","state":"confirmed","hash_key":"f11ed6ad40c9891558758fe852726198","meeting":24,"meta":{},"comments":[],"invitee":{"user":1082}}}}},"channel":"stream-feed_demo"},
                     {"event":"created","data":{"activity":{"id":56422,"created_at":"2012-06-18T14:53:39Z",
                      "updated_at":"2012-06-18T14:53:39Z","kind":"meeting","tag":"created",
                      "scheduled":false,"timestamp":"2012-06-18T14:53:38Z","meta":{},"comments":[],
                      "owner":{"user":{"id":1082,"created_at":"2012-06-14T16:02:47Z",
                      "updated_at":"2012-06-14T16:02:47Z","name":"Angela Marshall",
                      "email":"demo@feed-demo.com","phone":"127407572326","public":true,
                      "meta":{"feed":{"start_date":"2012-05-14","end_date":"2013-06-14","current_date":"2012-06-14"}},
                      "api_key":"feed_demo",
                      "avatar":{"small_url":"/images/fallback/small_default.png","medium_url":
                      "/images/fallback/medium_default.png","large_url":"/images/fallback/large_default.png",
                      "huge_url":"/images/fallback/huge_default.png"},"account":27}},
                      "reference":{"meeting":{"id":24,"created_at":"2012-06-18T14:53:38Z",
                        "updated_at":"2012-06-18T14:53:38Z","topic":"Yet Another meeting",
                        "location":"Location","starts_at":"2012-06-18T01:02:00Z","ends_at":
                        "2012-06-18T01:02:00Z","meta":{},"contacts":[],"users":[1082],
                        "invitations":[{"id":34,"created_at":"2012-06-18T14:53:38Z",
                        "updated_at":"2012-06-18T14:53:38Z","state":"confirmed",
                        "hash_key":"f11ed6ad40c9891558758fe852726198","meeting":24,"meta":{},
                        "comments":[],"invitee":{"user":1082}}],"attachments":[],"comments":[]}}}},
                     "channel":"stream-feed_demo"}];

    var instance = Pusher.instances[0];

    events.forEach(function(act){
      instance.channel('stream-' + $.cookie('user_api_key')).emit('created', act);
    });
  },
  feedUpdate: function(data){
    console.log('feed update');
  },
  streamCreated: function(data){
    console.log(data);
  },
  streamUpdated: function(data){
    console.log(data);
  },
  steamDeleted: function(data){
    console.log('in deleted');
    console.log(data);
  },
  streamReceive: function(evt, data){
    if(Radium.Pusher.streamChannelEvents.indexOf(evt) === -1){
      console.log(evt);
      return;
    }
  }
});
