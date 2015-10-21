export function initialize(application) {
  const registry = application.registry;

  registry.injection('component', 'flashMessenger', 'service:flash-messenger');
  registry.injection('controller', 'flashMessenger', 'service:flash-messenger');
  registry.injection('route', 'flashMessenger', 'service:flash-messenger');
}

export default {
  name: 'load-services',
  initialize: initialize,
  after: 'store'
};