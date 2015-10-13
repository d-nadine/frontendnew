import User from "radium/models/user";
import d from "radium/utils/date-time";

export function initialize(container, application) {
  container.lookup('service:authManager');

  application.deferReadiness();

  User.find({name: 'me'}).then((records) => {
    const user = records.get('firstObject');

    window.Intercom("boot", {
      app_id: window.INTERCOM_APP_ID,
      email: user.get('email'),
      user_id: user.get('id'),
      created_at: user.get('createdAt').toUnixTimestamp(),
      widget: {
        activator: "#IntercomDefaultWidget"
      },
      increments: {
        number_of_clicks: 1
      }
    });

    console.log(user.get('createdAt').toUnixTimestamp());

    application.advanceReadiness();
  });
}

export default {
  name: 'auth',
  initialize: initialize,
  after: 'load-services'
};
