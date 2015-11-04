import Ember from 'ember';

const {
  Mixin
} = Ember;

export default Mixin.create({
  actions: {
    showContactDrawer(contact, hideMain) {
      this.closeContactDrawer();

      Ember.assert('You have passed a non contact instance to showContactDrawer', contact.constructor === Radium.Contact);

      const dynamicParams = {
        context: contact,
        bindings: [
          {name: 'parent', value: this, static: true},
          {name: "closeDrawer", value: "closeContactDrawer", static: true},
          {name: "lists", value: "lists"},
          {name: "addList", value: "addContactList", static: true},
          {name: "customFields", value: "customFields"},
          {name: "deleteContact", value: "deleteContact", static: true},
          {name: "hideMain", value: hideMain, static: true},
          {name: "contact", value: contact, static: true}
        ]
      };

      Ember.run.next(() => {
        this.set('contactParams', dynamicParams);

        this.set('displayContactDrawer', true);
      });
    },

    closeContactDrawer() {
      this.closeContactDrawer();

      return false;
    }
  },

  closeContactDrawer() {
    if(this.isDestroyed || this.isDestroying) {
      return;
    }

    this.set('contactParams', null);
    this.set('displayContactDrawer', false);
  },

  displayContactDrawer: false,
  contactParams: null
});
