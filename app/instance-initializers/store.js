import Store from 'radium/store';

export function initialize(application) {
  application.Store = Store;
}

export default {
  name: 'store-compatibility',
  before: 'store',
  initialize: initialize
};
