import Model from 'radium/models/models';

const ContactInfo = Model.extend({
  socialProfiles: DS.hasMany('Radium.SocialProfile')
});

ContactInfo.toString = function(){
  return "Radium.ContactInfo";
};

export default ContactInfo;
