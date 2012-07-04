Radium.PageScroller = Ember.Mixin.create(Ember.Evented{
  page: 1,
  canScroll: true,
  shouldScroll: function(scrollData){
    if(scrollData.direction === Radium.SCROLL_FORWARD){
      return false;
    }

    return this.get('canScroll');
  },
  loadFeed: function(options){
    if(!this.get('canScroll')){
      return;
    }

    var url = '/api/contacts?page=%@'.fmt(this.get('page'));

    var self = this;

    getContacts = $.getJSON(url);

    getContacts.success(function(data){
      debugger;
    });

    getContacts.error(function(response){
      debugger;
      console.log(response.responseText);
    })
  }
});
