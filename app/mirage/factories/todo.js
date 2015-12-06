import Mirage, {faker} from 'ember-cli-mirage';

export default Mirage.Factory.extend({
  time() {
    return new Date();
  },

  description() {
    return faker.lorem.sentence();
  },

  finished() {
    return false;
  },

  finishBy() {
    return moment().add('days', 7);
  }
});
