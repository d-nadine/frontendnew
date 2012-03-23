Radium.ContactCardView = Ember.View.extend({
  templateName: 'contact_card',
  classNames: "contact-card row span9".w(),
  classNameBindings: ['content.isSelected:selected'],
  selectedFilterBinding: 'Radium.selectedContactsController.selectedFilter',
  selectedLetterBinding: 'Radium.selectedContactsController.selectedLetter',
  isVisible: function() {
    var status = this.getPath('content.status'),
        todos = this.getPath('data.todos.length'),
        firstLetter = this.getPath('content.firstLetter'),
        isAssigned = this.getPath('content.user'),
        selectedLetter = this.get('selectedLetter'),
        selectedFilter = this.get('selectedFilter');

    if (!selectedFilter) {

      if (selectedLetter) {
        if (selectedLetter !== firstLetter) {          
          return false;
        }
      }
    } else {
      if (selectedFilter === 'unassigned') {
        if (isAssigned) {
          return false;
        }
      }

      if (selectedFilter === 'no_tasks') {
        if (todos > 0) {
          return false;
        }
      }

      if (status !== selectedFilter) {
        return false;
      }

      if (selectedLetter) {
        if (selectedLetter !== firstLetter) {          
          return false;
        }
      }
    }

    return true;
  }.property(
    'selectedFilter', 
    'selectedLetter',
    'content.firstLetter', 
    'content.status', 
    'content.unassigned',
    'content.todos'
  ).cacheable(),

  contactPageLink: Ember.Button.extend({
    tagName: 'a',
    attributeBindings: ['href'],
    href: function() {
      return '/contacts/%@'.fmt(this.getPath('content.id'))
    }.property('content'),
    click: function() {
      var contact = this.get('content');
      Radium.selectedContactController.set('content', contact);
    }
  }),

  sendContactMessage: function(event) {
    var contact = this.get('content');
    contact.set('isSelected', true);
    Radium.App.send('addResource', {
      form: "ContactsMessage",
      data: contact  
    });
    return false;
  }
});