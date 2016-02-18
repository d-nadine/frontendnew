import Mirage, {faker}  from 'ember-cli-mirage';

export default Mirage.Factory.extend({
  created_at() {
    return new Date();
  },

  description() {
    return faker.lorem.sentence();
  },

  ends_at() {
    return moment().add(7, 'days');
  },


  starts_at() {
    return moment().add(7, 'days');
  },

  location() {
    return "somewhere";
  },

  topic() {
    return "a meeting";
  }
});
