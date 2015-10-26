import Ember from 'ember';

//import avatar from './avatar';

export function dynamicAvatar() {
  // var args = Array.prototype.slice.call(arguments, 2);

  // context = property.hasOwnProperty("context") ? this.get(property.context) : context;

  // args.unshift(context);

  // options.types = [context];

  // options.hash.style = "contacts-table";

  // return Ember.Handlebars.helpers.avatar.apply(context, args);
}

export default Ember.Helper.helper(dynamicAvatar);
