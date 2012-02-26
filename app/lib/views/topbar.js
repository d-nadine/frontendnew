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
    buttonTitle: function() {
      var section = this.getPath('parentView.currentSection'),
          sectionText = "";
      switch (section) {
        case 'dashboard':
          sectionText = "Todo";
          break;
        case 'deals':
          sectionText = "Deal";
          break;
        case 'campaign':
          sectionText = "Campaign";
          break;
        default:
          sectionText = "Contact";
          break;
      };
      return sectionText;
    }.property('parentView.currentSection').cacheable(),
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
      var section = this.getPath('parentView.currentSection');

      switch (section) {
        case 'dashboard':
          Radium.App.send('addResource', 'Todo');
          break;
        case 'deals':
          Radium.App.send('addResource', 'Deal');
          break;
        case 'campaign':
          Radium.App.send('addResource', 'Campaign');
          break;
        default:
          Radium.App.send('addResource', 'Contact');
          break;
      };
      
    },
    disabled: function() {
      var formState = Radium.App.get('currentState').name;
      return (formState === '.form') ? true : false;
    }.property('Radium.App.currentState').cacheable(),
    template: Ember.Handlebars.compile('Add {{ buttonTitle }}')
  }),
  templateName: 'topbar'
});