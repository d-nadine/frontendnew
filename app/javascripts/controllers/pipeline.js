Radium.pipelineController = Ember.Object.create({
  filterTypes: [
    {
      title: 'Everything', 
      shortname: 'everything', 
      hasForm: false
    },
    {
      title: 'Leads', 
      shortname: 'leads', 
      hasForm: false
    },
    {
      title: 'Prospects', 
      shortname: 'prospects', 
      hasForm: false
    },
    {
      title: 'Opportunities', 
      shortname: 'rejected', 
      hasForm: false
    },
    {
      title: 'Customers', 
      shortname: 'rejected', 
      hasForm: false
    },
    {
      title: 'Dead Ends', 
      shortname: 'rejected', 
      hasForm: false
    }
  ],
});