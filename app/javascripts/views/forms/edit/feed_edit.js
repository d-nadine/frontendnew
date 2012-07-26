Radium.FeedEditView = Ember.View.extend({
  classNames: ['well', 'form-inline'],
  contentBinding: 'parentView.parentVIew.content',
  classNameBindings: ['content.isSaving'],
  userSelect: Ember.Select.extend({
    init: function() {
      this._super();
      var assignedTo = this.getPath('parentView.content.user');
      this.set('selection', assignedTo);
    },
    didInsertElement: function() {
      this.$().focus();
    },
    contentBinding: 'Radium.usersController.content',
    optionLabelPath: 'content.name',
    optionValuePath: 'content.id',
    assignmentDidChange: function() {
      var user = this.get('selection'),
          reference = this.getPath('parentView.content'),
          oldUser = reference.get('user');

      if (user.get('id') !== reference.getPath('user.id')) {
        reference.setProperties({
          user: user,
          user_id: user.get('id')
        });

        // TODO: Update client side relations
        // user.get('references').pushObject(reference);
        // oldUser.get('references').removeObject(reference);
        Ember.run.next(function() {
          Radium.store.commit();
        });
      }
    }.observes('selection')
  })
});