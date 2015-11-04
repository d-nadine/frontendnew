export function initialize(application) {
  const registry = application.registry;

  registry.injection('component', 'flashMessenger', 'service:flash-messenger');
  registry.injection('controller', 'flashMessenger', 'service:flash-messenger');
  registry.injection('route', 'flashMessenger', 'service:flash-messenger');

  registry.injection('component', 'EventBus', 'service:event-bus');

  registry.injection('component', 'uploader', 'service:uploader');

  registry.injection('component', 'store', 'store:main');
}

export default {
  name: 'load-services',
  initialize: initialize,
  after: 'store'
};
