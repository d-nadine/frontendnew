  Radium.CallListForm = Radium.FormView.extend(Radium.FormReminder, {
    templateName: 'call_list_form',
    selectedContactIdsBinding: 'Radium.contactsController.selectedContactsIds',

    findContactsField: Radium.AutocompleteTextField.extend({
      select: function(event, ui) {
        var contact = Radium.store.find(Radium.Contact, ui.item.value);
        contact.set('isSelected', true);
        this.$().val('');
      }
    }),

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
            data: data
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