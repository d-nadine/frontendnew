Radium.TopbarView = Ember.View.extend({
  currentSectionBinding: 'Radium.appController.currentSection',
  section: function() {
    var section = this.get('currentSection') || 'dashboard';
    return (section === 'dashboard') ? 'Todo' : 'Contact';
  }.property('currentSection').cacheable(),
  highlightNav: function() {
    var section = this.get('currentSection') || 'dashboard';
    $('ul#main-nav').find('li')
      .removeClass('active')
      .filter('li#btn-' + section).addClass('active');
  }.observes('currentSection'),
  didInsertElement: function() {
    var section = this.get('currentSection') || 'dashboard';
    if (section) $('li#btn-'+section).addClass('active');
  },
  // Main action button in the topbar, changes depending on section
  mainActionButton: Ember.Button.extend({
    classNames: "btn pull-right".w(),
    isVisible: function() {
      var section = this.getPath('parentView.currentSection');
      if (!section || section === 'settings') {
        return false;
      } else {
        return true;
      }
      return false;
    }.property('parentView.currentSection'),
    hasAddedForm: false,
    click: function() {
      Radium.App.send('loadForm', 'Todo');
    },
    disabled: function() {
      var formState = Radium.App.getPath('loggedIn.dashboard.isFormAddView');
      return (formState) ? true : false;
    }.property('Radium.App.loggedIn.dashboard.isFormAddView').cacheable(),
    template: Ember.Handlebars.compile('Add {{ parentView.section }}')
  }),
  templateName: 'topbar'
});