import Mirage, {faker} from 'ember-cli-mirage';

export default Mirage.Factory.extend({
  name() {
    return faker.company.companyName;
  }
});
