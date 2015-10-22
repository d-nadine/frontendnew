import Mirage from 'ember-cli-mirage';

export default Mirage.Factory.extend({
  gateway_identifier() {return "23i43242";},
  token() {return "token";},
  subscription_ended() {return false;},
  gateway_set() {return false;}
});
