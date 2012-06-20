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

    streamChannel.bind_all(this.streamReceive);
  },
  feedUpdate: function(data){
    console.log('feed update');
  },
  streamReceive: function(evt, data){
    if(Radium.Pusher.streamChannelEvents.indexOf(evt) === -1){
      console.log(evt);
      return;
    }

    var method = 'stream' + evt.charAt(0).toUpperCase() + evt.slice(1);

    Radium.Events[method](data);
  }
});
