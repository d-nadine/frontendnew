Radium.LoggedOutState = Ember.State.create({
  initialState: 'loginForm',
  loginForm: Ember.ViewState.create({
    view: Radium.LoginPane,
    enter: function(manager) {
      $.cookie('user_api_key', null, {path: '/', domain: '.radiumcrm.com'});
      manager.set('isLoggedin', false);
      this._super(manager);
    }
  }),
  error: Ember.ViewState.create({
    view: Ember.View.extend({
      templateName: 'error_page',
      isBugReportFormVisible: false,
      showBugReportForm: function(event) {
        this.set('isBugReportFormVisible', true);
        return false;
      },
      cancelBugReport: function(event) {
        this.set('isBugReportFormVisible', false);
        return false;
      },
      submitForm: function() {
        var self = this,
            $form = this.$('form'),
            $requiredFields = $form.find('.required'),
            $errorFields = $requiredFields.filter(function(index) {
              return ($(this).val() ===  '') ? true : false;
            }),
            values = $form.serializeObject(),
            bug = {bug: values};
        
        if ($errorFields.length) {
          $requiredFields.parent().parent().removeClass('error');
          $errorFields.each(function() {
            $(this).parent().parent().addClass('error');
          });
        } else {
          var ajax = {
            url: '/api/bugs',
            data: bug,
            type: 'post',
            success: function() {
              self.set('isBugReportFormVisible', false);
            }
          };
          
          $requiredFields.parent().parent().removeClass('error');
          $.ajax(ajax);
        }

        return false;
      }
    })
  })
});