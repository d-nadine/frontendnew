define('radium', ['jquery', 'ember'], function($, Ember){
  return window.Radium = Ember.Application.create({
    test: 'hi'
  });
  console.log('Radium Main');
});