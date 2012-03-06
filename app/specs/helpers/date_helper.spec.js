describe("Handlebars helpers", function() {
  
  describe("Date Helper", function() {
    var view, fixture;
    beforeEach(function() {
      fixture = $('<div/>');
      view = Ember.View.create({
        type: 'day',
        date: '2012-02-03',
        myDate: Ember.DateTime.create({
          year: '2012', month: '02', day: '03'
        }),
        template: Ember.Handlebars.compile('<h1>{{formatDate myDate}}</h1>')
      });
    });

    afterEach(function() {
      view.destroy();
    });

    it("converts a date object into a string", function() {
      view.set('myDate', new Date('Sat Apr 21 2012 11:28:42 GMT-0700 (PDT)'));
      Ember.run(function() {view.appendTo(fixture);});
      expect(fixture.find('h1').text()).toEqual('April 21, 2012');
    });

    it("outputs a formatted DateTime object day", function() {
      view.set('type', 'day');
      Ember.run(function() {view.appendTo(fixture);});
      expect(fixture.find('h1').text()).toEqual('February 3, 2012');
    });

    it("outputs a formatted DateTime object week", function() {
      view.set('type', 'week');
      Ember.run(function() {view.appendTo(fixture);});
      expect(fixture.find('h1').text()).toEqual('Week 05, 2012');
    });

    it("outputs a formatted DateTime object month", function() {
      view.set('type', 'month');
      Ember.run(function() {view.appendTo(fixture);});
      expect(fixture.find('h1').text()).toEqual('February 2012');
    });
    
    it("outputs a formatted DateTime object quarter", function() {
      view.set('type', 'quarter');
      Ember.run(function() {view.appendTo(fixture);});
      expect(fixture.find('h1').text()).toEqual('1st Quarter, 2012');
    });
    
    it("outputs a formatted DateTime object year", function() {
      view.set('type', 'year');
      Ember.run(function() {view.appendTo(fixture);});
      expect(fixture.find('h1').text()).toEqual('2012');
    });
  });
});