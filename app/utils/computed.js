import Ember from 'ember';

const {
  computed
} = Ember;

export function primary(collection) {
  const dependentKey = `${collection}.@each.isPrimary`;

  return computed(dependentKey, function() {
    if (! this.get(collection).get('length')) {
      return;
    }

    return this.get(collection).find((item) => {
      return item.get('isPrimary');
    });
  });
}
