import Mirage, {faker} from 'ember-cli-mirage';

export default Mirage.Factory.extend({
  tag() {
    return faker.list.random('contact');
  },

  event() {
    return faker.list.random('create');
  },

  description() {
    return faker.lorem.sentence();
  },

  time() {
    return new Date();
  },

  external_link() {
    return null;
  },

  public() { return true; }
});
