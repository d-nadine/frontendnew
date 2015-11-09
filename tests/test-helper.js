import resolver from './helpers/resolver';

import "./helpers/fillin-contenteditable";
import "./helpers/fillin-with-keyevents";

import {
  setResolver
} from 'ember-qunit';

setResolver(resolver);
