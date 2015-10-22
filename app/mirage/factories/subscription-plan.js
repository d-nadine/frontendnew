import Mirage, { faker } from 'ember-cli-mirage';

export default Mirage.Factory.extend({
  plan_id() {
    return faker.list.random("startup", "growth", "business");
  },
  name() { return this.plan_id()().capitalize(); },
  total_users() { return 5;},
  disabled() {return false;},
  currency() {return 'US';}
});
