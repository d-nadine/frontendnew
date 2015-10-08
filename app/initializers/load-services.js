export function initialize(container, application) {
  application.inject('component', 'authManager', 'service:authManager');
}

export default {
  name: 'load-services',
  initialize: initialize,
  after: 'store'
};
