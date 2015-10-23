import Ember from 'ember';

const {
  Route
} = Ember;

export default Route.extend({
  queryParams: {
    user: {
      refreshModel: true
    }
  },

  beforeModel(transition) {
    const type = transition.params.conversations.type;

    if (!['team', 'shared'].contains(transition.params.conversations.type)){
      delete transition.params.conversations.user;
    }
    return type;
  },

  model(params) {
    console.log(params);
  }
});
