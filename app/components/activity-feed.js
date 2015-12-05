import Ember from 'ember';

const {
  Component,
  computed,
  A:emberArray
} = Ember;

export default Component.extend({
  classNames: ['feed'],

  activities: computed('subject.activities.[]', function() {
    const activities = this.get('subject.activities');

    if(!activities) {
      return emberArray();
    }
    const valid = activities.filter((activity) => {
      return activity.get('isLoaded') && !activity.get('isDeleted');
    });

    return valid.toArray().sort((a, b) => {
      return Ember.DateTime.compare(b.get('time'), a.get('time'));
    });
  })
});
