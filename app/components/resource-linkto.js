import Ember from 'ember';

const {
  LinkComponent
} = Ember;

const typeToLinks = {
  email: 'emails.show',
  meeting: 'calendar.task',
  todo: 'calendar.task'
};

export default LinkComponent.extend({
  willRender() {
    // FIXME: allow for css classes and query params
    Ember.assert('you must specify a resource', this.attrs.resource);

    const resource = this.attrs.resource;

    let resourceRoute = resource.value.humanize();

    if(typeToLinks[resourceRoute]) {
      resourceRoute = typeToLinks[resourceRoute];
    }

    this.set('attrs', {
      params: [resource.value.get('displayName'), resourceRoute, resource],
      view: this.parentView,
      hasBlock: false,
      escaped: true
    });

    this._super(...arguments);
  }
});
