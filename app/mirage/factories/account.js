import Mirage, { faker } from 'ember-cli-mirage';

export default Mirage.Factory.extend({
  name() {return faker.company.companyName;},
  subscription_invalid() {return false;},
  is_trial() {return false;},
  unlimited() {return false;},
  imported_contactsGlobal() {return false;},
  currency() {return 'US';}
});
