import Mirage/*, {faker} */ from 'ember-cli-mirage';

export default Mirage.Factory.extend({
  incoming() {return 5;},
  replied() {return 6;},
  waiting() {return 7;},
  later() {return 8;},
  users_totals() {return [];},
  all_users_totals() {return 0;},
  shared_totals() {return [];}
});
