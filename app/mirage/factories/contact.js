import Mirage, {faker} from 'ember-cli-mirage';

export default Mirage.Factory.extend({
  name() { return `${faker.name.firstName()} ${faker.name.lastName()}`;},
  title() { return faker.name.title();},
  email_addresses() {
    return [{
      name: 'work',
      address: function() {
        return `${this.name()}@gmail.com`;
      },
      primary: true
    }];
  }
});
