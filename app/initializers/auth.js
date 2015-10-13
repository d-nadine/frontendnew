import User from "radium/models/user";

export function initialize(container, application) {
  const authManager = container.lookup('service:authManager');

  application.deferReadiness();

  User.find({name: 'me'}).then((records) => {
    const user = records.get('firstObject')

    application.advanceReadiness();
  });
}

export default {
  name: 'auth',
  initialize: initialize,
  after: 'load-services'
};
