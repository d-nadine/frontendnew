import Ember from 'ember';

const {
  Mixin
} = Ember;

export const TemplatePlaceholderMap = {
  "name": "name",
  "first_name": "first name",
  "last_name": "last name",
  "company_name": "company",
  "signature": "signature"
};

export const FallbackMap = {
  "name": "Hi there",
  "first_name": "",
  "last_name": "",
  "company_name": "your company",
  "signature": "Best Regards"
};

export const EditorMixin = Mixin.create({
  actions: {
    insertTemplate: function(template) {
      this.EventBus.publish("insertTemplate", template);
      if (template.get('attachments.length')) {
        template.get('attachments').forEach((attachment) => {
          this.get('form.files').pushObject(Ember.Object.create({
            attachment: attachment
          }));
        });
      }
    },

    insertPlaceholder: function(placeholder) {
      if (placeholder.template) {
        this.send('insertTemplate', placeholder.template);
      } else {
        this.EventBus.publish('placeholderInserted', placeholder);
      }
      return false;
    },

    toggleEditorToolbar: function() {
      this.$('.note-toolbar').slideToggle("slow");
      return this.$('.note-toolbar').toggleClass("toolbar-open");
    },

    insertCustomFieldPlaceholder: function(field) {
      this.EventBus.publish("customFieldInserted", field);
      return false;
    }
  },

  insertActions: Ember.computed(function() {
    const placeholderMap = Radium.TemplatePlaceholderMap;

    const ret = Ember.A();

    let i;

    for (i in placeholderMap) {
      if (placeholderMap.hasOwnProperty(i)) {
        let display = placeholderMap[i];

        let item = Ember.Object.create({
          name: i,
          display: "{" + display + "}",
          curlyless: display
        });

        ret.pushObject(item);
      }
    }
    const templates = this.get('templates').toArray();

    if (!templates.get('length')) {
      return ret;
    }

    const templateOptions = templates.map(function(template) {
      let display = template.get('subject');

      return Ember.Object.create({
        name: display,
        display: "{" + display + "}",
        curlyless: display,
        template: template
      });
    });

    ret.pushObjects(templateOptions);

    return ret;
  }),

  customFieldPlaceholders: Ember.computed('customFields.[]', function() {
    const ret = Ember.A();

    const customFields = this.get('customFields') || Ember.A();

    if (!customFields.get('length')) {
      return ret;
    }

    return customFields.map(function(field) {
      return Ember.Object.create({
        field: field,
        display: "{" + (field.get('name')) + "}"
      });
    });
  }),

  allPlaceholders: Ember.computed('insertActions.[]', 'customFieldPlaceholders.[]', function() {
    const insertActions = this.get('insertActions') || Ember.A();

    const customFieldPlaceholders = this.get('customFieldPlaceholders') || Ember.A();

    return insertActions.concat(customFieldPlaceholders);
  })
});
