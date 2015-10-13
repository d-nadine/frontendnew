import Model from 'radium/models/models';
import SocialProfile from 'radium/models/social_profile';

const ContactInfo = Model.extend({
  socialProfiles: DS.hasMany('Radium.SocialProfile')
});

ContactInfo.toString = function(){
  return "Radium.ContactInfo";
};

export default ContactInfo;