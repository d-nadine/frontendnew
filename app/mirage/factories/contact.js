import Mirage, {faker} from 'ember-cli-mirage';

export default Mirage.Factory.extend({
  name() { return `${faker.name.firstName()} ${faker.name.lastName()}`;},
  title() { return faker.name.title();},

  public() {
    return false;
  },

  email_addresses() {
    return [
      {
        name: "primary",
        value: `${this.name.replace(' ', '.').toLowerCase()}@gmail.com`,
        primary: true
      }
    ];
  }
});
