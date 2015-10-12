import RESTAdapter from 'radium/adapters/rest';

const Store = DS.Store.extend({
  revision: 14,
  adapter: RESTAdapter.extend({
    bulkCommit: false
  })
});

export default Store;
