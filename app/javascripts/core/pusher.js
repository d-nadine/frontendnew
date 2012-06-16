Radium.Pusher = Ember.Object.extend({
  pusher_appkey: '41649d2cdf5ab855c8a3',
  init: function(){
    this.pusher = new Pusher(this.pusher_appkey);

    this.pusher.connection.bind('state_change', function(states){
      console.log(states.current);
    });

    var feedChannel = this.pusher.subscribe('feed-feed_demo');

    feedChannel.bind_all(this.receiveAll);

    var streamChannel = this.pusher.subscribe('stream-feed_demo');
    
    streamChannel.bind_all(this.receiveAll);
  },
  pusher: null,
  receiveAll: function(evt, data){
    var message = (typeof evt === "string") ? evt : evt.data;

    console.log(message);

    if(message === "pusher_internal:subscription_succeeded" || message === "pusher:subscription_succeeded"){
      return;
    }

    debugger;

  },
  feedReceive: function(evt, data){
  },
  streamReceive: function(evt, data){
  }
});
