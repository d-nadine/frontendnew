import Mirage, {faker} from 'ember-cli-mirage';

export default Mirage.Factory.extend({
  name() {
    return faker.commerce.productName();
  },

  description() {
    return faker.lorem.sentence();
  },

  value() {
    return faker.commerce.price();
  },

  expectedCloseDate() {
    return moment().add('d', 5);
  }
});
