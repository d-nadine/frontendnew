Radium.SelectedContactController = Ember.ArrayProxy.extend(Radium.FeedScroller, {
  contact: null,
  contactLoaded: function(){
    if(!this.getPath('contact.isLoaded')){
      return;
    }

    var url =  Radium.get('appController').getFeedUrl('contacts', this.getPath('contact.id'));

    // if(!currentDate){
    //   this.get('content').pushObject({message: "There is no activity for this contact."});
    //   return;
    // }

    var options = this.getFeedOptions.call(this, url);

    this.loadFeed({direction: Radium.SCROLL_BACK}, options);

  }.observes('Radium.selectedContactController.contact.isLoaded'),

  isFollowing: function() {
    var userId = this.getPath('user.id'),
        followers = this.getPath('contact.followers');
    return followers.getEach('id').indexOf(userId) !== -1;
  }.property('contact.followers'),

  toggleFollowing: function(event) {
    var contactId = this.getPath('contact.id'),
        url = "/contacts/%@/follow".fmt(contactId);
    $.ajax({
      url: url,
      type: 'POST',
      context: this,
      success: function(data) {
        this.getPath('contact.followers').push(this.get('user'));
      }
    });
    return false;
  }
});

