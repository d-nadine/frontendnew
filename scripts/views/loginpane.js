define(function(require) {
  require('ember');
  var Radium = require('radium');
  
  var template = require('text!templates/login.handlebars'),
      loginPane;

  loginPane = Ember.View.extend({
    elementId: 'login-pane',
    template: Ember.Handlebars.compile(template),
    loginButton: Ember.Button.extend({
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
      
  return loginPane;
  
});