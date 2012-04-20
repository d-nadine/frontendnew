Radium.MeetingForm = Radium.FormView.extend({
  templateName: 'meeting_form',

  submitForm: function() {
    var self = this;
    var topic = this.$('#topic').val(),
        day = this.$('#start-date').val(),
        startsAt = this.$('#start-time').val(),
        startsAtMeridian = this.$('#start-time-meridian').val(),
        endsAt = this.$('#end-time').val(),
        endsAtMeridian = this.$('#end-time-meridian').val(),
        invitees = this.$('#invitees').val(),

        startsAtValue = this.timeFormatter(day, startsAt, startsAtMeridian),
        endsAtValue = this.timeFormatter(day, endsAt, endsAtMeridian),

        data = {
          meeting: {
            topic: topic,
            starts_at: startsAtValue,
            ends_at: endsAtValue,
            invite: invitees
          }
        },
        settings = {
          url: '/meetings',
          type: 'POST',
          data: JSON.stringify(data)
        },
        request = jQuery.extend(settings, CONFIG.ajax);
        
    // Disable the form buttons
    this.sending();
    
    
    $.ajax(request)
      .success(function(data) {
        Radium.store.load(Radium.Meeting, data);
        self.success("Meeting created");
      })
      .error(function(jqXHR, textStatus, errorThrown) {
        self.error("Oops, %@.".fmt(jqXHR.responseText));
      });
  
  }
});