import Mirage, {faker} from 'ember-cli-mirage';

export default Mirage.Factory.extend({
  tag() {
    return faker.list.random('contact');
  },

  event() {
    return faker.list.random('create');
  },

  time() {
    return new Date();
  },

  public() { return true; }
});
