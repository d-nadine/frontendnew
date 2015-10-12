import Store from 'radium/store';

export function initialize(container, applicaiton) {
  applicaiton.Store = Store;
}

export default {
  name: 'store-compatibility',
  before: 'store',
  initialize: initialize
};
