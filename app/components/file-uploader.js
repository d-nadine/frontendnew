import Ember from 'ember';

const {
  computed
} = Ember;

export default Ember.TextField.extend({
  type: 'file',
  attributeBindings: ['multiple'],
  multiple: true,

  isLargeAvatar: computed('avatarsize', function() {
    return this.get('avatarsize') === 'large';
  }),

  change: function(e) {
    const input = e.target;

    if (!Ember.isEmpty(input.files)) {
      this.set('files', input.files);
    }
  }
});
