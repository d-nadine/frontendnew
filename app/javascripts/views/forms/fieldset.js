Radium.Fieldset = Ember.View.extend({
  tagName: 'fieldset',
  classNames: ['control-group'],
  classNameBindings: ['isError:error'],
  
  isError: function() {
    return (this.getPath('errors.length')) ? true : false;
  }.property('errors.@each').cacheable(),
  invalidFieldsBinding: 'parentView.invalidFields',
  attributeBindings: ['for'],
  fieldAttributes: function() {
    return this.get('label').dasherize() || "";
  }.property('label').cacheable(),
  templateName: 'fieldset'
});