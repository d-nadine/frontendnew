Radium.DealForm = Radium.FormView.extend({
  templateName: 'deal_form',
  selectedContactsBinding: 'Radium.contactsController.selectedContacts',
  submitForm: function() {
    var self = this;
    var contact = this.$('#contact-id').val(),
        description = this.$('#description').val(),
        amount = this.$('#amount').val(),
        closeByDate = this.$('#close-date').val(),
        closeByTime = this.$('#close-time').val(),
        closeByMeridian = this.$('#end-time-meridian').val(),
        closeByValue = this.timeFormatter(closeByDate, closeByTime, closeByMeridian),
        user = this.$('select#assigned-to').val(),
        state = this.$('#state').val(),
        data = {
          deal: {
            description: description,
            close_by: closeByValue,
            amount: amount,
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