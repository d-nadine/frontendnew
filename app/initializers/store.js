import Store from 'radium/store';

export function initialize(container, application) {
  application.Store = Store;
}

export default {
  name: 'store-compatibility',
  before: 'store',
  initialize: initialize
};
