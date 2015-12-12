import Ember from 'ember';

export function listSeperator(params) {
  const index = params[0],
        length = params[1];

  if(index === (length - 1)) {
    return '';
  }

  return Ember.String.htmlSafe(', ');
}

export default Ember.Helper.helper(listSeperator);
