import Ember from 'ember';

const {
  computed,
  A: emberArray
} = Ember;

export function primary(collection) {
  const dependentKey = `${collection}.@each.isPrimary`;

  return computed(dependentKey, function() {
    if (! this.get(collection).get('length')) {
      return undefined;
    }

    return this.get(collection).find((item) => {
      return item.get('isPrimary');
    });
  });
}

export function aggregate(...properties) {
  const args = properties.map(function(prop) {
    return `${prop}.[]`;
  });

  const func = () => {
    const result = emberArray();

    properties.forEach((prop) => {
      this.get(prop).forEach((item) => {
        const observer = () => {
          if(!item.get('isLoaded')) {
            return;
          }

          item.removeObserver('isLoaded', observer);

          result.addObject(item);
        };

        if(item.get('isLoaded')) {
          observer();
        } else {
          item.addObserver('isLoaded', observer);
        }
      });
    });
  };

  return computed(args, func);
}
