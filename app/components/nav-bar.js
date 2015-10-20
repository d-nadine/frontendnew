import Ember from 'ember';

export default Ember.Component.extend({
  attributeBindings: ['role'],
  classNames: ['topbar', 'navbar navbar-inverse navbar-fixed-top'],
  role: 'header',

  _setup: Ember.on('didInsertElement', function(){
    this._super.apply(this, arguments);

    const contactsNav = this.$('.addressbook-top-nav');

    contactsNav.on('mouseenter', () => {
      if(this.get('application.currentPath') === 'addressbook.companies') {
        return;
      }

      contactsNav.addClass('open');
    });

    contactsNav.on('mouseleave', () => {
      contactsNav.removeClass('open');
    });

    contactsNav.on('click', 'a', () => {
      contactsNav.removeClass('open');
    });

    this.$('.addressbook-top-nav .dropdown-menu').on('click', 'a', () => {
      contactsNav.removeClass('open');
    });

    const collapse = this.$('.nav-collapse');

    collapse.on('click', 'a', () => {
      collapse.collapse('hide');
    });
  }),
  _teardown: Ember.on('willDestroyElement', function() {
    this._super.apply(this, arguments);
    this.$('.nav-collapse').off('click');
    this.$('.addressbook-top-nav').off('mouseenter').off('mouseleave').off('click');
    this.$('.addressbook-top-nav .dropdown-menu').off('click');
  })
});
