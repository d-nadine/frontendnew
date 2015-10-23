import Mirage, {faker} from 'ember-cli-mirage';

export default Mirage.Factory.extend({
  name() { return `${faker.name.firstName()} ${faker.name.lastName()}`;},
  title() { return faker.name.title();},
  email_addresses() {
    return [{
      name: 'work',
      address: `${this.first_name()}.${this.last_name()}@gmail.com`,
      primary: true
    }];
  }
});
