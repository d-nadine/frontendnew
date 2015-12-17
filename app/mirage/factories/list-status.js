import Mirage, {faker} from 'ember-cli-mirage';

export default Mirage.Factory.extend({
  name() {
    return faker.commerce.productName();
  },

  status_type() {
    return "active";
  },

  position() {
    return 1;
  }
});
