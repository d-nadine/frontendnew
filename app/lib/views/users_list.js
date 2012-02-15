Radium.UsersListView = Ember.CollectionView.extend({
    tagName: 'ul',
    classNames: 'nav nav-tabs nav-stacked filters people'.w(),
    contentBinding: 'Radium.usersController',
    itemViewClass: Ember.View.extend({
      isEnabled: function() {
        return (this.getPath('parentView.selectedUser') === this.getPath('content.id')) ? true : false;
      }.property('parentView.selectedUser').cacheable(),
      classNameBindings: ['isEnabled:active'],
      viewUser: function(event) {
        var id = this.getPath('content.id');
        this.setPath('parentView.selectedUser', id);
        return false;
      },
      templateName: 'users_list'
    }),
    didInsertElement: function() {
      this._super();
      this.$().before('<h3>Team</h3>');
    }
  });