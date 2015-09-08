Radium.DealColumnsConfig = Ember.Mixin.create
  fixedColumns: Ember.A([
    {
      classNames: "name"
      heading: "Name"
      route: "deal"
      bindings: [{
        name: "model",
        value: "model"
      }
      {
        name: "placeholder",
        value: "Add Name",
        static: true
      },
      {
        name: "bufferKey",
        value: "name"
        static: true
      },
      {
        name: "routeAction",
        value: "showDealDrawer",
        static: true
      }]
      checked: true
      sortOn: "name"
      context: "model"
      component: 'editable-field'
    }
  ])
