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
        { name: "contact", value: "contact" }
      ],
      actions: [
        {name: "linkAction", value: "showContactDrawer"}
      ],
      component: 'contact-link'
    }
  ])
});
