import Model from 'radium/models/models';

import {
  primary
} from '../utils/computed';

const Contact = Model.extend({
  name: DS.attr('string'),
  title: DS.attr('string'),

  emailAddresses: DS.hasMany('Radium.EmailAddress'),

  primaryEmail: primary('emailAddresses')
});

export default Contact;

Contact.toString = function() {
  return "Radium.Contact";
};
