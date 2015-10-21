import Resolver from 'ember/resolver';
import config from '../../config/environment';

var resolver = Resolver.create();

resolver.namespace = {
  modulePrefix: config.modulePrefix,
  podModulePrefix: config.podModulePrefix
};

DS._setupContainer = function() {
  // FIXME: stop test build-registry trying to
  // register latest ember data transforms
};

export default resolver;
