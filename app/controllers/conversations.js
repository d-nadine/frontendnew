import Ember from 'ember';
import ColumnsConfig from 'radium/mixins/conversations-columns-config';

const {
  Controller
} = Ember;

export default Controller.extend(ColumnsConfig, {
  queryParams: ['user']
});
