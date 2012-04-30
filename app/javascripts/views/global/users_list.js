Radium.UsersListView = Radium.FeedFilterView.extend({
  elementId: 'user-list',
  classNames: 'filters people'.w(),
  contentBinding: 'Radium.usersController.content',
  filterBinding: 'Radium.feedByUserController.filter',
  itemViewClass: Ember.View.extend({
    tagName: 'li',
    templateName: 'users_list',
    classNameBindings: ['isSelected:active'],
    userUrl: function() {
      return '/users/' + this.getPath('content.id');
    }.property('content.id').cacheable(),
    isSelected: function() {
      return (this.getPath('parentView.filter') == this.getPath('content.id')) ? true : false;
    }.property('parentView.filter').cacheable(),
    
    // Actions
    setFilter: function(event) {
      if (this.get('isSelected')) {
        this.setPath('parentView.filter', null);
      } else {
        var id = this.getPath('content.id');
        this.setPath('parentView.filter', id);
      }
      return false;
    }
  })
});