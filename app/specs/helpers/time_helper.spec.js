describe("Handlebars Date Helper", function() {
  
  var view, fixture;
  beforeEach(function() {
    fixture = $('<div/>');
    view = Ember.View.create({
      myDate: Ember.DateTime.create({
        year: '2012', month: '02', day: '03',
        hour: '09', minute: '28'
      }),
      template: Ember.Handlebars.compile('<h1>{{time myDate}}</h1>')
    });
  });

  afterEach(function() {
    view.destroy();
  });
  
  it("outputs abbreviated time", function() {
    Ember.run(function() {view.appendTo(fixture);});
    expect(fixture.find('h1').text()).toEqual('9:28 AM');
  });

  it("converts regular date objects", function() {
    var time = Ember.DateTime.create().toFormattedString('%i:%M %p');
    view.set('myDate', new Date());
    Ember.run(function() {view.appendTo(fixture);});
    expect(fixture.find('h1').text()).toEqual(time);
  });

  it("parses ISO8601 strings", function() {
    view = Ember.View.create({
      myDate: '2012-02-21T19:22:54Z',
      template: Ember.Handlebars.compile('<h1>{{time myDate}}</h1>')
    });
    Ember.run(function() {view.appendTo(fixture);});
    expect(fixture.find('h1').text()).toEqual('11:22 AM')
  });
});