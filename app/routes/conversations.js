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
    let user;

    const args = {
      name: params.type,
      pageSize: 5
    };

    if((user = params.user)) {
      args.user = user;

      this.controllerFor('conversations').set('user', user);
    }

    return Radium.Email.find(args);
  },

  setupController(controller, model) {
    this._super(...arguments);

    controller.set('model', model.toArray());
  }
});
