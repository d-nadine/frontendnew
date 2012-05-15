Radium.Activity = Radium.Core.extend({
  tag: DS.attr('string'),
  kind: DS.attr('string'),
  timestamp: DS.attr('date'),
  owner: DS.attr('object'),
  reference: DS.attr('object'),
  comments: DS.hasMany('Radium.Comment', {
    embedded: true
  }),

  // Embedded models
  todo: DS.belongsTo('Radium.Todo', {embedded: true}),
  // todo: DS.attr('object'),
  deal: DS.belongsTo('Radium.Deal', {embedded: true}),
  message: DS.belongsTo('Radium.Message', {embedded: true}),
  email: DS.belongsTo('Radium.Email', {embedded: true}),
  campaign: DS.belongsTo('Radium.Campaign', {embedded: true}),
  contact: DS.belongsTo('Radium.Contact', {embedded: true}),
  group: DS.belongsTo('Radium.Group', {embedded: true}),
  meeting: DS.belongsTo('Radium.Meeting', {embedded: true}),
  phoneCall: DS.belongsTo('Radium.PhoneCall', {
    embedded: true,
    key: 'phone_call'
  }),

  isCall: function() {
    if (this.get('reference').hasOwnProperty('todo')) {
      return this.getPath('reference.todo.kind') === 'call';
    } else {
      return false;
    }
  }.property('reference.todo.kind').cacheable(),

  isTodoFinished: function() {
    return this.get('tag') === 'finished';
  }.property('tag').cacheable()
  // referenceID: function() {
  //   var type = this.get('type');
  //   return this.getPath('data.reference.'+type+'.id');
  // }.property('data', 'type').cacheable(),
  // action: function() {
  //   return this.get('tags').objectAt(1);
  // }.property('tags').cacheable(),
  // type: function() {
  //   if (this.getPath('data.reference.todo')) return "todo";
  //   if (this.getPath('data.reference.deal')) return "deal";
  //   if (this.getPath('data.reference.meeting')) return "meeting";
  //   if (this.getPath('data.reference.campaign')) return "campaign";
  //   if (this.getPath('data.reference.message')) return "message";
  //   if (this.getPath('data.reference.call_list')) return "calllist";
  //   if (this.getPath('data.reference.announcement')) return "announcement";
  //   if (this.getPath('data.reference.contact')) return "contact";
  // }.property('data').cacheable()
  
});