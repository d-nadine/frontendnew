import Ember from 'ember';

export function truncate(params, options) {
  const text = params[0],
        maximum = options.length || 25;

  if(!text) {
    return "";
  }

  if(text.length >= maximum) {
    return Ember.String.htmlSafe(text.slice(0, maximum - 3));
  } else {
    return Ember.String.htmlSafe(text);
  }
}

export default Ember.HTMLBars.makeBoundHelper(truncate);
