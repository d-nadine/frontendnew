Radium.TopbarView = Ember.View.extend({
  currentPageBinding: 'Radium.appController.currentPage',
  section: function() {
    var section = this.get('currentPage') || 'dashboard';
    return (section === 'dashboard') ? 'Todo' : 'Contact';
  }.property('currentPage').cacheable(),
  highlightNav: function() {
    var section = this.get('currentPage') || 'dashboard';
    $('ul#main-nav').find('li')
      .removeClass('active')
      .filter('li#btn-' + section).addClass('active');
  }.observes('currentPage'),
  didInsertElement: function() {
    var section = this.get('currentPage') || 'dashboard';
    if (section) $('li#btn-'+section).addClass('active');
  },
  // Main action button in the topbar, changes depending on section
  mainActionButton: Ember.Button.extend({
    classNames: "btn pull-right".w(),
    buttonTitle: function() {
      var section = this.getPath('parentView.currentPage'),
          sectionText = "";
      switch (section) {
        case 'dashboard':
          sectionText = "Todo";
          break;
        case 'deals':
          sectionText = "Deal";
          break;
        case 'campaigns':
          sectionText = "Campaign";
          break;
        default:
          sectionText = "Contact";
          break;
      };
      return sectionText;
    }.property('parentView.currentPage').cacheable(),
    isVisible: function() {
      var section = this.getPath('parentView.currentPage');
      if (!section || section === 'settings') {
        return false;
      } else {
        return true;
      }
      return false;
    }.property('parentView.currentPage'),
    hasAddedForm: false,
    click: function() {
      var formName = this.$().text().replace('Add ', '');
      Radium.FormManager.send('showForm', {
        form: formName
      });
    },
    template: Ember.Handlebars.compile('Add {{ buttonTitle }}')
  }),
  templateName: 'topbar'
});