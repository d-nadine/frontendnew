Radium.Pusher = Ember.Object.create({
  pusher_appkey: '41649d2cdf5ab855c8a3',
  feedChannelEvents: ['update'],
  streamChannelEvents: ['created', 'Updated', 'deleted'],
  init: function(){

    this.pusher = new Pusher(this.pusher_appkey);

    this.pusher.connection.bind('state_change', function(states){
      console.log(states.current);
    });

    var feedChannel = this.pusher.subscribe('feed-' + $.cookie('user_api_key'));

    feedChannel.bind_all(this.feedReceive);

    var streamChannel = this.pusher.subscribe('stream-' + $.cookie('user_api_key'));
    
    streamChannel.bind_all(this.receiveAll);
  },
  receiveAll: function(evt, data){
    var message = (typeof evt === "string") ? evt : evt.data;

    console.log(message);

    if(message === "pusher_internal:subscription_succeeded" || message === "pusher:subscription_succeeded"){
      return;
    }

    debugger;

  },
  feedReceive: function(evt, data){
    if(Radium.Pusher.feedChannelEvents.indexOf(evt) === -1){
      console.log(evt);
      return;
    }

    debugger;
  },
  streamReceive: function(evt, data){
  }
});
