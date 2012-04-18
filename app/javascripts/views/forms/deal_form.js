Radium.DealForm = Radium.FormView.extend({
  templateName: 'deal_form',
  selectedContactsBinding: 'Radium.contactsController.selectedContacts',
  submitForm: function() {
    var self = this;
    var contact = this.$('#contact-id').val(),
        description = this.$('#description').val(),
        amount = this.$('#amount').val(),
        closeByDate = this.$('#close-date').val().split('-'),
        closeByTime = this.$('#close-time').val().split(':'),
        user = this.$('select#assigned-to').val(),
        state = this.$('#state').val(),
        data = {
          deal: {
            description: description,
            close_by: Ember.DateTime.create({
              year: closeByDate[0],
              month: closeByDate[1],
              day: closeByDate[2],
              hour: closeByTime[0],
              minute: closeByTime[1]
            }).toISO8601(),
            amount: amount
            user_id: user,
            contact_id: contact,
            state: state
          }
        };

    // Disable the form buttons
    this.sending();
    
  
    $.ajax({
      url: '/api/deals',
      type: 'POST',
      data: data,
      success: function(data) {
        self.success("Deal created");
      },
      error: function(jqXHR, textstate, errorThrown) {
        self.error("Oops, %@.".fmt(jqXHR.responseText));
      }
    });
  
  }
});