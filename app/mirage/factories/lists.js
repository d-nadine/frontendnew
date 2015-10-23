import Mirage, {faker} from 'ember-cli-mirage';

export default Mirage.Factory.extend({
  name() {return faker.commerce.product();},
  item_name() {return faker.commerce().product();},
  type() {
    return faker.list.random('contacts', 'companies');
  },
  configurable() {return false;}
});
