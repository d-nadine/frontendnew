Radium.UsersListView = Ember.CollectionView.extend({
    tagName: 'ul',
    classNames: 'nav nav-tabs nav-stacked filters people'.w(),
    contentBinding: 'Radium.usersController',
    itemViewClass: Ember.View.extend({
      isSelected: function() {
        var selectedUser = this.getPath('parentView.selectedUser'),
            user = this.getPath('content.id');
        return (selectedUser === user) ? true : false;
      }.property('parentView.selectedUser').cacheable(),
      classNameBindings: ['isSelected:active'],
      viewUser: function(event) {
        var id = this.getPath('content.id');
        if (this.get('isSelected')) {
          // this.setPath('parentView.selectedUser', null);
        } else {
          // this.setPath('parentView.selectedUser', this.getPath('content'));
          var activity = Radium.store.find(Radium.Activity, {
            type: 'user',
            id: id
          });
          Radium.activitiesController.set('content', activity);
        }
        return false;
      },
      templateName: 'users_list'
    }),
    didInsertElement: function() {
      this._super();
      this.$().before('<h3>Team</h3>');
    }
  });