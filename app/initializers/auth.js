export function initialize(container, application) {
  const authManager = container.lookup('service:authManager');
}

export default {
  name: 'auth',
  initialize: initialize,
  after: 'load-services'
};
