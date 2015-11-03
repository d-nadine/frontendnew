import Mirage, {faker} from 'ember-cli-mirage';

export default Mirage.Factory.extend({
  subject() {
    return faker.lorem.words();
  },
  body() {
    return faker.lorem.paragraphs();
  },
  send_time() {
    return new Date();
  },
  folder() {
    return "INBOX";
  }
});
