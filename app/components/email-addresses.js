import Ember from 'ember';

import MultipleBaseComponent from "radium/components/multiple-base-component";

import {sortByPrimary} from "radium/utils/computed";

const {
  A: emberArray
} = Ember;

export default MultipleBaseComponent.extend({
  isEditing: false,
  relationship: "emailAddresses",

  emailAddresses: emberArray(),

  sortedEmailAddresses: sortByPrimary('model', 'emailAddresses'),

  emailValidations: ['email']
});