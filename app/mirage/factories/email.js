import Mirage, {faker} from 'ember-cli-mirage';

export default Mirage.Factory.extend({
  subject() {
    return faker.lorem.words().join(' ');
  },
  body() {
    return faker.lorem.paragraphs();
  },
  send_time() {
    return new Date();
  },
  folder() {
    return "INBOX";
  },
  created_at() {return new Date();},
  updated_at() {return new Date();}
});
