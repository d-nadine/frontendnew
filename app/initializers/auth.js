export function initialize(container, application) {
  const authManager = container.lookup('service:authManager'),
        store = container.lookup('store:main');

  application.deferReadiness();

  store.query("user", {name: 'me'}).then((results) =>{
    debugger;

    application.advanceReadiness();
  });
}

export default {
  name: 'auth',
  initialize: initialize,
  after: 'load-services'
};
