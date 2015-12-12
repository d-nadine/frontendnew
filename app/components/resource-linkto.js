import Ember from 'ember';

const {
  LinkComponent
} = Ember;

const typeToLinks = {
};

export default LinkComponent.extend({
  willRender() {
    // FIXME: allow for css classes and query params
    Ember.assert('you must specify a resource', this.attrs.resource);

    const resource = this.attrs.resource.value;

    Ember.assert('you must supply a valid resource to resource-linkto', resource);

    let resourceRoute = resource.humanize();

    if(typeToLinks[resourceRoute]) {
      resourceRoute = typeToLinks[resourceRoute];
    }

    this.set('attrs', {
      params: [resource.get('displayName'), resourceRoute, resource],
      view: this.parentView,
      hasBlock: false,
      escaped: true
    });

    this._super(...arguments);
  }
});
