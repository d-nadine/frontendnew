Radium.UsersListView = Ember.View.extend({
  contentBinding: 'Radium.usersController.content',
  templateName: 'users_list'
});

Radium.UserListItemView = Ember.View.extend({
  tagName: 'li',
  isSelected: function() {
    var selectedUser = this.getPath('parentView.selectedUser'),
        user = this.get('user');
    return (selectedUser === user) ? true : false;
  }.property('parentView.selectedUser').cacheable(),
  classNameBindings: ['isSelected:active'],
  viewUser: function(event) {
    var id = this.getPath('user.id');
    if (this.get('isSelected')) {
      this.setPath('parentView.selectedUser', null);
    } else {
      Radium.store.adapter.set('selectedUserID', id);
      this.setPath('parentView.selectedUser', this.get('user'));
      Radium.App.send('loadFeed', {
        type: 'user',
        id: id
      });
    }
    return false;
  },

  // The badge count of leads
  userCount: Ember.View.extend({
    tagName: 'span',
    classNames: 'label label-important pull-right'.w(),
    classNameBindings: ['isHigh:label-success'],
    isHigh: function() {
      return (this.getPath('parentView.user.prospects.length') > 5) ? 
        true : false;
    }.property('parentView.user.prospects').cacheable(),
    template: Ember.Handlebars.compile('{{parentView.user.prospects.length}}')
  })
});