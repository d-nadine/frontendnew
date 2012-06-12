  Radium.AddToCallListForm = Radium.FormView.extend(Radium.FormReminder, {
    templateName: 'call_list_form',
    selectedContactIdsBinding: 'Radium.contactsController.selectedContactsIds',
    // TODO: Figure out how this works with the API...
    submitForm: function() {
      var self = this,
          $callListSelect = this.$('select#call-list'),
          finishByDate = this.$('input#finish-by').val(),
          callListId = $callListSelect.val(),
          callList = Radium.store.find(Radium.CallList, callListId),
          callListName = callList.get('description'),
          callListContactsIds =callList.getPath('data.contacts'),
          selectedContactIds = this.get('selectedContactIds').getEach('id'),
          data = {
            call_list: {
              finish_by: finishByDate,
              contact_ids: callListContactsIds
            }
          };
      data.call_list.contact_ids.push(selectedContactIds);

      $.ajax({
          url: '/api/call_lists/%@'.fmt(callListId),
          type: 'PUT',
          data: JSON.stringify(data)
        })
        .success(function(data) {
          console.log("Contact added to %@".fmt(callListName));
          self.success("Contact added to <b>%@</b>".fmt(callListName));
        })
        .error(function(jqXHR, textStatus, errorThrown) {
          self.error("Oops, %@.".fmt(jqXHR.responseText));
        });
    }
  });