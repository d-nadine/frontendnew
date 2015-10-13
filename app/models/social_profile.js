import Model from 'radium/models/models';

const SocialProfile = Model.extend({
  type: DS.attr('string'),
  url: DS.attr('string'),
  userName: DS.attr('string')
});

export default SocialProfile;

SocialProfile.toString = function() {
  return "Radium.SocialProfile";
};
