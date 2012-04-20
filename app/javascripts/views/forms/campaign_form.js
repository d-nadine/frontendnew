  Radium.CampaignForm = Radium.FormView.extend({
    selectedContactsBinding: 'Radium.contactsController.selectedContacts',
    templateName: 'campaign_form',

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
      var self = this;
      var contactIds = this.get('selectedContacts').getEach('id'),
          name = this.$('#campaign-name').val(),
          target = this.$('#target').val(),
          endsByDate = this.$('#ends-by-date').val(),
          endsByTime = this.$('#ends-by-time').val(),
          endsByMeridian = this.$('#ends-by-meridian'),
          endsByValue = this.timeFormatter(endsByDate, endsByTime, endsByMeridian),
          currency = this.$('#currency').val(),
          description = this.$('#description').val(),
          user = this.$('select#assigned-to').val(),
          data = {
            campaign: {
              name: name,
              description: description,
              target: target,
              ends_at: endsByValue,
              user_id: user,
              contact_ids: contactIds,
              currency: currency
            }
          },
          settings = {
            url: '/api/campaigns',
            type: 'POST',
            data: JSON.stringify(data)
          },
          request = jQuery.extend(settings, CONFIG.ajax);

      // Disable the form buttons
      this.sending();
    
      $.ajax(request)
        .success(function(data) {
          Radium.store.load(Radium.Campaign, data);
          self.success("Campaign created");
        })
        .error(function(jqXHR, textstate, errorThrown) {
          self.error("Oops, %@.".fmt(jqXHR.responseText));
        });
    
    }
  });