import Ember from 'ember';

const {
  Mixin,
  A: emberArray
} = Ember;

export default Mixin.create({
  fixedColumns: emberArray([
    {
      heading: 'Contact',
      classNames: 'email-sender',
      bindings: [
        {
          name: "contact",
          value: "model.contact"
        }, {
          name: "linkAction",
          value: "showContactDrawer",
          "static": true
        }
      ],
      component: 'contact-link'
    }
  ])
});
