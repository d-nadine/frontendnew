import Mirage, {faker}  from 'ember-cli-mirage';

export default Mirage.Factory.extend({
  created_at() {
    return new Date();
  },

  description() {
    return faker.lorem.sentence();
  },

  ends_at() {
    return moment().add('days', 7);
  },


  starts_at() {
    return moment().add('days', 7);
  },

  location() {
    return "somewhere";
  },

  topic() {
    return "a meeting";
  }
});
