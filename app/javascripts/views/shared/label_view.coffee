Radium.LabelView = Ember.View.extend
  tagName: "span"
  classNames: ["label"]
  classNameBindings: [
    "isLead:label-info"
    "isProspect:label-warning"
    "isOpportunity:label-inverse"
    "isCustomer:label-success"
    "isDeadEnd:label-important"
  ]

  # Status type bindings
  isLead: (->
    (if (@get("label") is "lead") then true else false)
  ).property("label").cacheable()
  isProspect: (->
    (if (@get("label") is "prospect") then true else false)
  ).property("label").cacheable()
  isOpportunity: (->
    (if (@get("label") is "opportunity") then true else false)
  ).property("label").cacheable()
  isCustomer: (->
    (if (@get("label") is "customer") then true else false)
  ).property("label").cacheable()
  isDeadEnd: (->
    (if (@get("label") is "dead_end") then true else false)
  ).property("label").cacheable()

  template: Ember.Handlebars.compile("{{view.label}}")
