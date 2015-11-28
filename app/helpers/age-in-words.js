import Ember from 'ember';

export function ageInWords(params) {
  const value = params[0];

  if(!value) {
    return "Never";
  }

  const now = Ember.DateTime.create(),
        days = value.daysApart(now);

  let text;

  if(days === 0) {
    text = "New";
  } else if (days === 1) {
    text = "1 day";
  } else {
    text = `${days} days`;
  }

  return Ember.String.htmlSafe(`<time>${text}</time>`);
}

export default Ember.Helper.helper(ageInWords);
