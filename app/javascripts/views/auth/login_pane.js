Radium.LoginPane = Ember.View.extend({
  elementId: 'login-pane',
  templateName: 'login',
  loginButton: Ember.View.extend({
    tagName: 'button',
    click: function() {
      var $form = $('form#login-form'),
          $fields = $form.find('input.span9');
          $hasValueFields = $fields.filter(function() {
                        return ($(this).val() !== '') ? true : false;
                      });
      // FIXME: Look into a better validation class
          if ($hasValueFields.length >= $fields.length) {
            Radium.App.send('logIn');
          } else {
            $fields
            .removeClass('error')
            .parent().removeClass('error')
            .end()
            .filter(function() {
              return $(this).val() === '';
            }).addClass('error').parent().addClass('error');
          }
      
    },
    template: Ember.Handlebars.compile('Login')
  })
});