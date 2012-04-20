  Radium.CallListForm = Radium.FormView.extend(Radium.FormReminder, {
    templateName: 'call_list_form',
    selectedContactIdsBinding: 'Radium.contactsController.selectedContactsIds',

    findContactsField: Radium.AutocompleteTextField.extend({
      sourceBinding: 'Radium.contactsController.contactNamesWithObject',
      select: function(event, ui) {
        var contact = ui.item.contact;
        contact.set('isSelected', true);
        this.set('value', null);
        event.preventDefault();
      }
    }),

    close: function() {
      Radium.contactsController.setEach('isSelected', false);
      this._super();
    },

    submitForm: function() {
      var self = this,
          description = this.$('#description').val(),
          finishByDate = this.$('#finish-by-date').val(),
          finishByTime = this.$('#finish-by-time').val(),
          finishByMeridian = this.$('#finish-by-meridian').val(),
          finishByValue = this.timeFormatter(finishByDate, finishByTime, finishByMeridian),
          user = this.$('#user').val(),
          campaign = this.$('#campaign').val(),
          selectedContactIds = this.get('selectedContactIds').getEach('id'),

          data = {
            call_list: {
              description: description,
              finish_by: finishByValue,
              entries: callListContactsIds,
              campaign: campaign
            }
          },
          settings = {
            url: '/api/call_lists/',
            type: 'PUT',
            data: JSON.stringify(data)
          },
          request = jQuery.extend(settings, CONFIG.ajax);

      $.ajax(request)
        .success(function(data) {
          console.log(data);
          self.success("Call List created");
        })
        error(function(jqXHR, textStatus, errorThrown) {
          self.error("Oops, %@.".fmt(jqXHR.responseText));
        });
    }
  });