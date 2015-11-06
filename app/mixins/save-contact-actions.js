import Ember from 'ember';

const {
  Mixin
} = Ember;

export default Mixin.create({
  actions: {
    saveCompany(context) {
      if (Ember.isEmpty(context.get('bufferedProxy.companyName')) && context.get('model.company')) {
        context.set('bufferedProxy.removeCompany', true);
        context.set('bufferedProxy.company', null);
      }
    },

    afterSaveCompany: function() {
      //FIXME: update addresssbook
      //this.get('addressbook').send('updateTotals');
      return false;
    }
  }
});