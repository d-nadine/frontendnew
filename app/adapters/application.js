import DS from 'ember-data';
import ENV from 'frontend/config/environment';

export default DS.JSONAPIAdapter.extend({
  host: ENV.apiHost,

  query (store, type, query, recordArray) {
    const queryMethod = `query${type.modelName.capitalize()}Records`;

    if(query = this[queryMethod]) {
      return query.call(this, type, query, recordArray);
    }

    return this._super.apply(this, arguments);
  },

  queryUserRecords (store, type, query, recordArray) {
    if(query.query.name === "me" ) {
      const url = `${this._buildURL(type.modelName)}/users/me`;

      return this.ajax(url, "GET");
    }

    return this._super.apply(this, arguments);
  }
});
