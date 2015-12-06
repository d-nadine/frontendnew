import Ember from 'ember';

export function capitalize(params) {
  const value = params[0];

  if(!value) {
    return "";
  }

  return value.capitalize();
}

export default Ember.Helper.helper(capitalize);
