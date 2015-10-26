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
    const type = transition.params.conversations.type,
          controller = this.controllerFor('conversations');

    if (!['team', 'shared'].contains(transition.params.conversations.type)){
      controller.set('user', null);
      delete transition.params.conversations.user;
    }

    controller.set('type', type);

    return type;
  },

  model(params) {
    console.log(params);
  }
});
