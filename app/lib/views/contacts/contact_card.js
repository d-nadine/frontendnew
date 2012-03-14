Radium.ContactCardView = Ember.View.extend({
  templateName: 'contact_card',
  classNames: "contact-card row span9".w(),
  classNameBindings: ['content.isSelected:selected'],
  selectedFilterBinding: 'Radium.selectedContactsController.selectedFilter',
  selectedLetterBinding: 'Radium.selectedContactsController.selectedLetter',
  isVisible: function() {
    var status = this.getPath('content.status'),
        todos = this.getPath('data.todos.length'),
        isAssigned = this.getPath('content.user'),
        selectedFilter = this.get('selectedFilter');

    if (!selectedFilter) {
      return true;
    }

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
    return true;
  }.property(
    'selectedFilter', 
    'selectedLetter', 
    'content.status', 
    'content.unassigned',
    'content.todos'
  ).cacheable()
});