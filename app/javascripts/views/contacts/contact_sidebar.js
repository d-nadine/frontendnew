Radium.ContactSidebar = Ember.View.extend({
  templateName: 'contact_sidebar',
  isFollowingString: function() {
    return (this.get('isFollowing')) ? "Following" : "Follow";
  }.property('isFollowing')
});
