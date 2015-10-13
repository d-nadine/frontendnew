import Ember from 'ember';
import User from 'radium/models/user';
import Account from 'radium/models/account';

export function initialize(container, application) {
  application.Account = Account;
  application.User = User;
}

export default {
  name: 'old-model-compat',
  initialize: initialize,
  before: 'store-compatibility'
};
