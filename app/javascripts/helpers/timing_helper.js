Ember.Handlebars.registerHelper('time', function(id, args) {
    console.time(id);
});

Ember.Handlebars.registerHelper('timeEnd', function(id) {
    console.timeEnd(id);
});

Ember.Handlebars.registerHelper('profile', function(id, args) {
    console.profile(id);
});

Ember.Handlebars.registerHelper('profileEnd', function(id) {
    console.profileEnd(id);
});
