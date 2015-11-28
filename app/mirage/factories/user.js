import Mirage, { faker } from 'ember-cli-mirage';

export default Mirage.Factory.extend({
  first_name() {return faker.name.firstName();},
  last_name() { return faker.name.lastName(); },
  email() {return `${this.first_name()}.${this.last_name()}@gmail.com`;},
  is_admin() {return true;},
  initial_mail_mported() {return true;},
  initial_contacts_imported() {return true;},
  refresh_failed() {return false;},
  subscription_invalid() {return false;},
  last_logged_in() {return new Date();},
  created_at() {return new Date();},
  updated_at() {return new Date();},
  activity_ids() {
    return {url: `/users/${faker.random.number()}/activities`};
  }
});
