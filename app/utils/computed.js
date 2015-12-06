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

export function primaryAccessor(collection, prop, dependentKey) {
  const accessKey = `${dependentKey}.${prop}`;

  return computed(accessKey, {
    get() {
      return this.get(accessKey);
    },

    set(key, value) {
      let hash;

      if(!this.get(dependentKey)) {
        hash = {
          name: 'work',
          isPrimary: true
        };

        hash[prop] = value;
        this.get(collection).createRecord(hash);
      } else {
        this.set(accessKey, value);
      }

      this.notifyPropertyChange(dependentKey);

      return value;
    }
  });
}

export function tasks(...properties) {
  const args = emberArray();

  properties.forEach((prop) => {
    args.push(`${prop}.@each.isFinished`);
    args.push(`${prop}.@each.isDeleted`);
  });

  const sortFunc = (left, right) => {
    if (!left.get('time') && !right.get('time')) {
      return Ember.compare(left.get("displayName"), right.get("displayName"));
    }

    if (left.get('time') && !right.get('time')) {
      return 1;
    } else if (!left.get('time') && right.get('time')) {
      return -1;
    }

    const compare = Ember.DateTime.compare(left.get("time"), right.get("time"));

    if (compare === 0) {
      return Ember.compare(left.get("displayName"), right.get("displayName"));
    } else {
      return compare;
    }
  };

  return computed(args, function(){
    const result = emberArray();

    properties.forEach((prop) => {
      this.get(prop).forEach((item) => {
        const observer = () => {
          if(!item.get('isLoaded')) {
            return;
          }

          if(item.get('isFinished') || item.get('isDeleted')) {
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

    return result.sort(sortFunc);
  });
}

export function aggregate(...properties) {
  const args = properties.map(function(prop) {
    return `${prop}.[]`;
  });

  return computed(args, function() {
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

    return result;
  });
}

export function isPrimaryComparer(left, right) {
  if(left.get('isPrimary')) {
    return -1;
  }

  if(right.get('isPrimary')) {
    return 1;
  }

  return 0;
}

export function sortByPrimary(key, relationship) {
  const path = key + "." + relationship;
  const arrayProp = path + ".[]";
  const isPrimaryProp = path + ".@each.isPrimary";

  const func = () => {
    var coll;
    if (!(coll = this.get(path))) {
      return;
    }
    return coll.toArray().sort(Radium.isPrimaryComparer);
  };

  return Ember.computed(arrayProp, isPrimaryProp, func);
}
